---
title: VPC Peer Backing Service Accesss
---

# Enable access to backing services via VPC peering

To assist tenants in migrating large databases away from GOV.UK PaaS, we allow private access to backing services over a VPC peering.

This is similar to [how we can allow tenant applications to reach services inside a VPC peer](/guides/vpc_peering/). If that is your use case
you should reach that guide instead. If your use case is two way communication, follow both guides.

## Who can use this

Opening up VPC peering arrangements with access to backing services has some risk for the platform, so we do not offer it to everyone. We will have a
short chat with the tenant about their needs to work out if we can or should help them, and we think that the rough eligibility criteria are one or more of

* a database in excess of 100gb
* a service with small downtime tolerances
* to migrating, or though, AWS

We cannot support private access directly to Azure, GCP, or a tenant's private data centre because of the burden it places on the team.

## Pre-requisites

Before you can set up private access to backing services, the tenant needs to have provided

* one or more VPC IDs to which we will peer, and the name of the environment it corresponds to on their side (e.g. dev, staging)
* thr AWS account ID for each VPC ID
* the CloudFoundry service GUIDs for each database they want private access to, and which of their VPCs should be able to access it

You should tell the tenant

* we will provide them a `/22` CIDR block in the `172.16.0.0/16` range on which to peer
* the CIDR ranges for all of our backing service subnets

Tenants are responsible for configuring their networks in such a way as to allow traffic to flow between their VPC and ours. We cannot provide
them with any formal support in doing so.

This information must be given in a support ticket. If the tenant is emailing the support address directly, the email must come from an
address associated with their CloudFoundry org. If they raise the ticket via our support form, they must be logged in first so that we can
see who raised it.

## Configuring and deploying private backing service access

1. Choose a subnet CIDR on which to peer. Look in `paas-cf/terraform/prod{-lon}.vpc_peering.json` for a list of current peerings, then choose the next highest subnet. The size should be `/22`. For example, if the highest subnet is `172.16.4.0/22`, choose `172.16.8.0/22`.
2. Create a new entry in `paas-cf/terraform/prod{-lon}.vpc_peering.json`. Set `backing_service_routing` to `true`. Deploy this to production.
3. Once it is in production, run

    ```
    PEER_NAME=VPC_PEER_NAME DB_INSTANCE_ID=RDS_INSTANCE_IDENTIFIER \
    gds aws AWS_ACCOUNT_ROLE -- make ENV enable_vpc_peer_db_access
    ```

   to add an extra security group to the database which allows ingress from the CIDR block, where

   * `VPC_PEER_NAME` is the name of a VPC peering configuration in the environment's VPC peering config file (e.g. [`prod-lon.vpc_peering.json`](https://github.com/alphagov/paas-cf/blob/main/terraform/prod-lon.vpc_peering.json))
   * `RDS_INSTANCE_IDENTIFIER` is the instance identifier of the database you are modifying. You can find this by entering the service instance guid into the AWS RDS console
   * `AWS_ACCOUNT_ROLE` is the name of the AWS account and the role you are assuming via the GDS CLI
   * `ENV` is the name of the GOV.UK PaaS environment (e.g. `dev01`, `prod`)
   
If the tenant also requires their GOV.UK PaaS apps to be able to communicate with services in their VPC, follow [the guide on regular VPC peering](/guides/vpc_peering/).

It is possible to perform a dry run of the script by setting the `DRY` environment variable to `true`. In a dry run, the script will print what it is going to do, but carry out no other actions.
