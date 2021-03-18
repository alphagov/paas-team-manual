---
title: VPC Peering
---

# VPC Peering

We use VPC peering to allow tenants to access resources they manage in another VPC somewhere on AWS. We grant access to the VPC on a per-space basis, although there is a shortcut to grant access to all existing spaces in an org.

## How to set it up

1. Choose a subnet CIDR that we'll ask the tenant to use. Look in `paas-cf/terraform/prod{-lon}.vpc_peering.json` for a list of current peerings, then choose the next highest subnet. The size should be `/22`. For example, if the highest subnet is `172.16.4.0/22`, ask the tenant to use `172.16.8.0/22`.
2. Tell the tenant to create a new VPC with the subnet you have given them, and ask them to give you both the VPC ID, and the AWS account ID the VPC resides in.
3. Create a new entry in `paas-cf/terraform/prod{-lon}.vpc_peering.json`. Deploy this to production.
4. A CF security group will have been automatically created that gives access to the peered VPC, the name of the group will be `vpc_peer_$PEER_NAME`. `cf bind-security-group` this to the spaces that the tenant needs access from.
6. Make sure the tenant knows that they need to allow `10.0.0.0/16` in any security groups attached to resources in their VPC, and that they need to raise a support request to have VPC access granted to any new spaces they create.
7. 🎉

## Things to note

* There is a hard limit of 125 VPC peerings per VPC, and the default limit is 50.
* There is a performance penalty to having many VPC peerings due to the performance of large route tables.
