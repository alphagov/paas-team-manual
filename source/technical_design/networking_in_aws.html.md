# Networking

This page describes the network layout in a single PaaS deployment on AWS.

## VPC

We use a single [virtual private cloud](https://aws.amazon.com/documentation/vpc/) (VPC), with IP range `10.0.0.0/16`.

Our VPC is in the `eu-west-1` region, in Ireland, and includes [subnets](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html)
in each of the `eu-west-1a`, `eu-west-1b`, and `eu-west-1c` [availability zones](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html) (AZs).

Since we run a VPC for each of our CI, Staging and Production environments, and for each developer's environment, we sometimes run into [limits](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Appendix_Limits.html) on the resources we are allowed to use.
We've raised various limits by submitting requests to Amazon.
The result (sometimes out of date) is recorded in a [spreadsheet](https://docs.google.com/spreadsheets/d/1ZkHASsyROKiixrvpV-ecePMqAj9zPAjQENQlsOh6QBc/edit#gid=0).

## Subnets

We have 5 subnets in each AZ.

`infra` handles outbound internet traffic.
It also contains Bosh, Concourse, and the bosh and cf RDS instances.

`cf` contains most Cloud Foundry components.

`router` contains the Router Cloud Foundry component.

`cell` contains the Cell Cloud Foundry component, for deploying tenant apps into.

`aws-backing-services` contains RDS instances dynamically created for tenants by the RDS broker.

We usually speak of an instance being in a subnet. This is not quite accurate, but is a useful shorthand.
Really, each instance has an [Elastic Network Interface](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ElasticNetworkInterfaces.html) (ENI) which has at least one private IP, among other attributes.
Instances can have more than one ENI, and ENIs can be moved between instances, although an instance's primary ENI can't be removed.

We use a single ENI per instance, each with a single private IP.
So each of our instances will only be in a single subnet.

## Internet Access

### Gateways

There is a single [Internet Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Internet_Gateway.html) for the entire VPC - it is an abstract service available anywhere that scales automatically.

We deploy a single [NAT Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html) in each AZ.

An Internet Gateway allows outbound and inbound traffic.
NAT Gateways only allow outbound traffic (but permit inbound traffic for outbound connections).

Gateways have to appear in the route table for a subnet for instances to use them.

### Elastic IPs

We allocate an [Elastic IP](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-ip-addressing.html#vpc-eips) address (EIP) to each NAT Gateway, and to each of the bosh and concourse EC2 instances.

The NAT Gateways each need an EIP to function.

The bosh and concourse VMs each need an EIP to allow making outbound connections to the internet to download dependencies.
They can't use the NAT Gateways for this because the NAT Gateways don't exist when concourse and bosh are first deployed and may be torn down afterwards in dev environments.

### ALBs

We allocate several [Application Load Balancers](http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html) (ALBs) to provide load-balanced SSL access to Concourse, logs and metrics, and some CF components.

An ALB has a presence in each AZ, and scales automatically with the traffic volume being balanced.

The scaling is transparent to the external user because each ALB provides a DNS name - IP addresses of additional ALB components are added automatically when the ALB scales.

ALBs also handle TLS termination. See [ADR 007](/architecture_decision_records/ADR007-terminating-tls-at-elbs).

We replaced the ELBs with ALBs. See [ADR 037](/architecture_decision_records/ADR035-do-not-use-haproxy-use-aws-alb).

## Subnet Routing

A subnet is called 'public' if the route table associated with it has a route to an internet gateway.

An instance in a public subnet can talk to the internet if it has a public or elastic IP address.

An instance in a private subnet can talk to the internet if it has a route to a NAT Gateway.
The NAT Gateway would be in a different subnet, since it needs to be in a public subnet to work.

Each subnet has an IP range to determine private IPs for instances within the subnet.

### Route tables

[Route tables](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Route_Tables.html) consist of a list of rules, each specifying a destination and an IP range.
For traffic to a given IP address, the most specific rule is chosen to determine the destination.

The special destination `local` routes traffic to any subnets in the VPC.

There is a main route table, which is default for any subnet without its own.
Our main route table only specifies a `local` route.

The route tables for the `cell`, `cf`, and `router` subnets also route internet traffic to the NAT Gateway for the AZ.

The route table for the `infra` subnets route internet traffic to the Internet Gateway.
The `infra` subnets are public, and are where the NAT Gateways are located.

Because the NAT Gateways are in the `infra` subnets, it isn't possible for VMs in `infra` to route via the NAT Gateways. A route targeting the NAT Gateway would preclude the NAT Gateway routing that traffic to the Internet Gateway.

### Routing on the instance

The OS running on a given instance has its own routing table.

This will route all traffic destined for the subnet of the instance via the appropriate interface.

It will also route all traffic that needs to leave the subnet via the reserved IP address of the [VPC Router](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html#VPC_Sizing) in that subnet.
The route table of the subnet determines where it goes from there.

On `cell` and `councourse` instances, the presence of lightweight containers means that the OS route table will contain additional routes for directing tenant traffic.

## Firewalls

There are two kinds of virtual firewall provided by AWS: [Security Groups](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html) and [Network ACLs](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html).

There is a [comparison document](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Security.html#VPC_Security_Comparison) if you want more details.

We chose to use Security Groups instead of Network ACLs to control traffic.

Security Groups operate at the instance level, while Network ACLs operate at the subnet level.

Security Groups are able to track connections, allowing traffic that would otherwise be blocked to flow so long as it is for a connection that was permitted in the first place.

Network ACLs are not able to deny incoming traffic while allowing responses to outgoing connections, which makes them awkward to use.
