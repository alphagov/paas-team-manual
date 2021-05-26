---
title: How to disable a single AZ on GOV.UK PaaS
---

# How to disable a single AZ on GOV.UK PaaS

There are scenarios, where we will need to manually disable a single AZ on AWS,
prompting the cells, traffic, scheduler and auctioneer to redistribute the
applications across the remaining AZs.

Scenario like this may be when we see an AZ being flappy in network connectivity
terms.

We've developed a way, to accomplish that, with either your dev machine and
Terraform, or simply running the appropriate Concourse job.

[The `paas-cf` repository][1] contains a terraform module, which will deny all
traffic, to subnets in one particular AZ.

It also has a Concourse jobs, in `create-cloudfoundry` pipeline, and the
`operator` groups, to bot disable and enable particular AZs.

_Please note_: Disabling the AZ `a`, will likely bring the Concourse down,
meaning the re-enabling action will need to be done by hand from op's machine.

This will involve, you having to download the Terraform state file, for that
particular region. See pipeline for more details.

[1]: https://github.com/alphagov/paas-cf/tree/main/terraform/az-management
