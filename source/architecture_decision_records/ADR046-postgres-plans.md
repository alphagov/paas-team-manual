---
title: ADR046 - Postgres Service Plans
---

# ADR046: Postgres Service Plans

## Context

GOV.UK PaaS runs a fork of the [RDS Service Broker](https://github.com/alphagov/paas-rds-broker) and uses it to provide Postgres database services
to its tenants.

As of writing, our service plan 'menu' looks like this:

```
$ cf marketplace -e postgres
Getting service plan information for service offering postgres in org gds-tech-ops / space sandbox as 117196824971928474330...

broker: rds-broker
   plan                            description                                                                                                                                                                          free or paid   costs   available
   tiny-unencrypted-10             5GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t2.micro. Free for trial orgs. Costs for billable orgs.    free                   yes
   small-10                        20GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t2.small.                                            paid                   yes
   small-ha-10                     20GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t2.small.                          paid                   yes
   medium-10                       100GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.large.                                           paid                   yes
   medium-ha-10                    100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.large.                         paid                   yes
   large-10                        512GB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.2xlarge.                                        paid                   yes
   large-ha-10                     512GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.2xlarge.                      paid                   yes
   xlarge-10                       2TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.4xlarge.                                          paid                   yes
   xlarge-ha-10                    2TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.4xlarge.                        paid                   yes
   tiny-unencrypted-11             5GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 11. DB Instance Class: db.t3.micro. Free for trial orgs. Costs for billable orgs.    free                   yes
   small-11                        100GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 11. DB Instance Class: db.t3.small.                                           paid                   yes
   small-ha-11                     100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 11. DB Instance Class: db.t3.small.                         paid                   yes
   medium-11                       100GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.large.                                           paid                   yes
   medium-ha-11                    100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.large.                         paid                   yes
   large-11                        512GB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.2xlarge.                                        paid                   yes
   large-ha-11                     512GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.2xlarge.                      paid                   yes
   xlarge-11                       2TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.4xlarge.                                          paid                   yes
   xlarge-ha-11                    2TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.4xlarge.                        paid                   yes
   tiny-unencrypted-10-high-iops   25GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t3.micro. Free for trial orgs. Costs for billable orgs.   free                   yes
   small-10-high-iops              100GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t3.small.                                           paid                   yes
   small-ha-10-high-iops           100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t3.small.                         paid                   yes
   medium-ha-10-high-iops          500GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m5.large.                         paid                   yes
   large-10-high-iops              2.5TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m5.2xlarge.                                        paid                   yes
   large-ha-10-high-iops           2.5TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m5.2xlarge.                      paid                   yes
   xlarge-10-high-iops             10TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m5.4xlarge.                                         paid                   yes
   xlarge-ha-10-high-iops          10TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m5.4xlarge.                       paid                   yes
   tiny-unencrypted-11-high-iops   25GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 11. DB Instance Class: db.t3.micro. Free for trial orgs. Costs for billable orgs.   free                   yes
   small-11-high-iops              100GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 11. DB Instance Class: db.t3.small.                                           paid                   yes
   small-ha-11-high-iops           100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 11. DB Instance Class: db.t3.small.                         paid                   yes
   medium-11-high-iops             500GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.large.                                           paid                   yes
   medium-ha-11-high-iops          500GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.large.                         paid                   yes
   large-11-high-iops              2.5TB Storage Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.2xlarge.                                paid                   yes
   large-ha-11-high-iops           2.5TB Storage Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.2xlarge.              paid                   yes
   xlarge-11-high-iops             10TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.4xlarge.                                         paid                   yes
   xlarge-ha-11-high-iops          10TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 11. DB Instance Class: db.m5.4xlarge.                       paid                   yes
   medium-10-high-iops             500GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m5.large.                                           paid                   yes
   tiny-unencrypted-12             5GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 12. DB Instance Class: db.t3.micro. Free for trial orgs. Costs for billable orgs.    free                   yes
   small-12                        100GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 12. DB Instance Class: db.t3.small.                                           paid                   yes
   small-ha-12                     100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 12. DB Instance Class: db.t3.small.                         paid                   yes
   medium-12                       100GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.large.                                           paid                   yes
   medium-ha-12                    100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.large.                         paid                   yes
   large-12                        512GB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.2xlarge.                                        paid                   yes
   large-ha-12                     512GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.2xlarge.                      paid                   yes
   xlarge-12                       2TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.4xlarge.                                          paid                   yes
   xlarge-ha-12                    2TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.4xlarge.                        paid                   yes
   tiny-unencrypted-12-high-iops   25GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 12. DB Instance Class: db.t3.micro. Free for trial orgs. Costs for billable orgs.   free                   yes
   small-12-high-iops              100GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 12. DB Instance Class: db.t3.small.                                           paid                   yes
   small-ha-12-high-iops           100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 12. DB Instance Class: db.t3.small.                         paid                   yes
   medium-12-high-iops             500GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.large.                                           paid                   yes
   medium-ha-12-high-iops          500GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.large.                         paid                   yes
   large-12-high-iops              2.5TB Storage Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.2xlarge.                                paid                   yes
   large-ha-12-high-iops           2.5TB Storage Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.2xlarge.              paid                   yes
   xlarge-12-high-iops             10TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.4xlarge.                                         paid                   yes
   xlarge-ha-12-high-iops          10TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 12. DB Instance Class: db.m5.4xlarge.                       paid                   yes
```

There's some background information needed to understand some decisions made when setting up our plans:
* [AWS's gp2 storage](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html#EBSVolumeTypes_gp2) scales at 3 IOPS per GB of volume size, between a base of 100 IOPS at 33.33GB
  disk size up to 16kIOPS at 5,334GB disk size.
* AWS does not provide gp3 storage for RDS.
* [RDS storage](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIOPS.StorageTypes.html) does not allow you to decrease storage of a database instance, or increase storage of
  a database instance without adding at least 10%.

We have identified several inconsistencies and issues with the current plans when studying them in
order of volume size.

## Problems and potential options

Replacing plans in this section refers to:
* renaming the existing plan to have a `-deprecated` suffix
* marking it private
* scoping it down to only the existing spaces using it
* creating a new one under its old name, with new configuration

This way, we avoid problems with billing and existing service instances using these plans.

### Problem 1

There is no upgrade path available from `medium` `high-iops` plans to `large` plans, because of the
  RDS 10% storage increase rule - 500GB to 512GB would violate it.
1. We could replace the `medium` `high-iops` plans with ones of smaller disk space, say 465GB (`⌊512/1.1⌋`).
   * This would leave existing users of these plans (6 instances) unable to upgrade (both in terms
     of plan size and database version) without going up to `large`.
2. We could replace the `large` plans with ones of larger disk space, say 564GB (`⌈512*1.1⌉`).

### Problem 2

The `small` plans are inconsistent - `small-10` (and `small-ha-10`) provide 20GB disk space, but
  the Postgres 11 and 12 variants provide 100GB disk space.
1. We could replace the `small-11`, `small-ha-11`, `small-12`, and `small-ha-12` plans with 20GB
   editions.
   * This would leave existing users of these plans (170 instances) unable to upgrade (both in
     terms of plan size and database version) without going up to `small` `high-iops` or `medium`.
2. We could replace the `small-10` and `small-ha-10` plans with 100GB editions.
   * This would make approximately zero sense as they'd be identical to the `small-10-high-iops`
     and `small-ha-10-high-iops plans`.
3. We could do nothing and leave it be. It's not technically breaking anything irght now.
   * This might create a dilemma when we come to introduce `small-13` and `small-ha-13`. Should it
     be 20GB or 100GB? `small-13-high-iops` and `small-ha-13-high-iops` will be 100GB so it would
     be illogical, however if we went for 20GB, there would be no `small-12` -> `small-13` upgrade path.

### Problem 3

The Postgres engine version is part of the plans themselves. It is not relevant to billing or
particularly how the underlying resource is structed on AWS.

1. We could make it a config option.
   * This might make the broker more complex as we'd have to handle existing instances.
2. We could do nothing and leave it be.
   * This means a lot of duplication and potential for inconsistency (e.g., as we've seen between
     small-10 and small-12).

### Problem 4

The disk space is part of the plans but this leads to massive jumps in plan whenever you just want
a bit more disk space.
1. We could make it a config option.
   * We'd have to factor this into billing.
   * This might make the broker more complex as we'd have to handle existing instances.
2. We could do nothing and leave it be.
   * Problem to solve in a future PaaS? Would future PaaS even want to do service plans? Probably,
     but we shouldn't pre-empt it.

### Problem 5

It's not clear that users know there could be legitimate reasons to want to upgrade from
  `medium` `high-iops` to `large` (non-`high-iops`). If a user doesn't understand the disk space
  <-> IOPS link, they might have `medium` `high-iops`, need more RAM/a bigger CPU/more connections,
  and decide straight to `large` `high-iops` instead of plain `large`.
1. We could add IOPS information to each plan's description.
   * These descriptions are already quite wordy and this would make things worse.
2. We could do nothing and leave it be.

### Problem 6

The `xlarge` `high-iops` plans provide a disk larger than that needed to achieve maximum
 AWS gp2 IOPS.
1. We could make future xlarge `high-iops` plans 5,334GB in disk size.
   * However there would then be no upgrade path for the current user.
2. We could do nothing and leave it be.

## Summary

In conclusion, with the service plan system we've backed ourselves into a corner with some not very
good ways out.

## Decision

We will take these actions:
* Problem 1: Action 2 - replace the `large` plans with 564GB versions
* Problem 2: Action 3 - do nothing for now
* Problem 3: Action 2 - do nothing for now
* Problem 4: Action 2 - do nothing for now
* Problem 5: Action 2 - do nothing for now
* Problem 6: Action 2 - do nothing for now

## Status

Accepted

## Consequences

* Users on `medium` `high-iops` plans will be able to upgrade to `large`.
* Existing `large` users will be able to move to the new `large` plans at will through the usual
  service instance update mechanism.
* We will effectively introduce new `large` `-deprecated` plans which are private to the existing
  users.
* Various oddities will remain in our current plan 'menu'.
