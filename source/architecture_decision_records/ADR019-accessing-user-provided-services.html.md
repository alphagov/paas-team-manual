---
title: ADR019 - Accessing user provided services
---

# ADR019: Accessing user provided services

## Context

A service that's onboarding at the moment depends on MySQL, memcached and
elasticsearch that we don't yet offer, but are likely to in future, and has
chosen to host them on AWS using RDS MySQL, Elasticache memcached and hosted
Elasticache.

We wanted to ensure that only the app instances belonging to that service could
connect to those services in order to avoid other services being able to access or modify their data.

- MySQL requires authentication and allows TLS
- Elasticache memcached does not provide authentication or TLS
- AWS Hosted elasticsearch [appears to provide the ability to sign
  elasticsearch requests using an AWS access
key](https://aws.amazon.com/blogs/security/how-to-control-access-to-your-amazon-elasticsearch-service-domain/).
Requiring a custom elasticsearch client.

The options for authentication are:

Via Internet, using network access controls
-------------------------------------------

This is described for
[elasticache](http://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/Access.Outside.html)

How we would set it up:

- Tenant binds services to public IP addresses, restricts access to PaaS egress IPs.
- PaaS team changes default [application security
  group](https://docs.cloudfoundry.org/adminguide/app-sec-groups.html) set to
 forbid access to those IP addresses.
- PaaS team creates new application security group allowing access to those IP addresses.
- PaaS team binds application security group to space(s) belonging to tenants

Risks/costs:

- Access via Internet IP is via NAT instance, introducing a likely single point
  of failure and additional running costs to tenants.
- Traffic is in plaintext over the Internet for some services.
- PaaS team need to do work every time a tenant adds/changes service IP addresses.
- If they forget to request this, other PaaS tenants have access to their
  service IPs.
- PaaS team need to do work (assigning application security groups) in every
  occasion a space needs to gain or lose
  access to the list of service IPs.


Using private address space (VPC peering)
-----------------------------------------

How we would set it up:

- Tenant raises support request to begin setup process
- PaaS team responds with a unique IP allocation eg. 172.16.0.0/24 for tenant to use
- Tenant creates VPC using that address space
- Tenant creates AWS security group(s) restricting access from PaaS VPC to expected services
- Tenant provides PaaS team with their AWS account id and the VPC id.
- PaaS team sends VPC peering request
- PaaS team creates new application security group allowing access to the VPC IP allocation
- PaaS team binds application security group to space(s) belonging to tenants
- Tenant accepts VPC peering request

Risks/costs:

- Introduces a new network security boundary between VPCs; a risk of
  accidentally introducing security group rules that allow more access from the
  peered VPC than intended.
- PaaS team need to do work (assigning application security groups) on every
  occasion a space needs to gain or lose
  access to the peered VPC.

Although this specific example uses VPC peering because the tenant in question
uses AWS, we could use the same principle (us assigning IP address space and
changing application security groups) to a VPN or some other network overlay
technology to allow us to connect to things other than VPCs.

## Decision

We will offer VPC peering to tenants in specific cases where it is appropriate.

## Consequences

Where we don't presently offer a specific backing-service, tenants have an
option to provision their own service and access it without having to expose it
to the Internet. The process for doing this is documented
[here](/guides/vpc_peering/).
