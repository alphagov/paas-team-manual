---
title: ADR036 - Recommended database plans
---

# ADR036: Recommended database plans
==========================

<!-- vim: set tw=100: -->

Context
-------

### Current plans

As of 2019-09-03 [GOV.UK PaaS](https://cloud.service.gov.uk) offers the following postgres and mysql
plans to everyone:

#### MySql

| service plan           | description                                                                                                                    | free or paid |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------|--------------|
|#  tiny-unencrypted-5.7   | 5GB Storage, NOT BACKED UP, Dedicated Instance. MySQL Version 5.7. DB Instance Class: db.t2.micro.                             | free |
|#  medium-ha-5.7          | 100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.m4.large.     | paid |
|#  large-ha-5.7           | 512GB Storage, Dedicated Instance, Highly Available, Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.m4.2xlarge.   | paid |
|#  xlarge-ha-5.7          | 2TB Storage, Dedicated Instance, Highly Available, Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.m4.4xlarge.     | paid |
|#  small-ha-5.7           | 20GB Storage, Dedicated Instance, Highly Available. Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.t2.small.      | paid |
|#  small-5.7              | 20GB Storage, Dedicated Instance, Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.t2.small.                        | paid |
|#  medium-5.7             | 100GB Storage, Dedicated Instance, Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.m4.large.                       | paid |
|#  large-5.7              | 512GB Storage, Dedicated Instance, Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.m4.2xlarge.                     | paid |
|#  xlarge-5.7             | 2TB Storage, Dedicated Instance, Storage Encrypted. MySQL Version 5.7. DB Instance Class: db.m4.4xlarge.                       | paid |

#### Postgres

| service plan           | description                                                                                                                                                        | free or paid |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------|
|#  tiny-unencrypted-9.5   | 5GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.t2.micro.                               | free |
|#  medium-ha-9.5          | 100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.m4.large.      | paid |
|#  large-ha-9.5           | 512GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.m4.2xlarge.   | paid |
|#  xlarge-ha-9.5          | 2TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.m4.4xlarge.     | paid |
|#  small-ha-9.5           | 20GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.t2.small.       | paid |
|#  small-9.5              | 20GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.t2.small.                         | paid |
|#  medium-9.5             | 100GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.m4.large.                        | paid |
|#  large-9.5              | 512GB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.m4.2xlarge.                     | paid |
|#  xlarge-9.5             | 2TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 9.5. DB Instance Class: db.m4.4xlarge.                       | paid |
|#  tiny-unencrypted-10    | 5GB Storage, NOT BACKED UP, Dedicated Instance, Max 50 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t2.micro.                                | free |
|#  small-10               | 20GB Storage, Dedicated Instance, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t2.small.                          | paid |
|#  small-ha-10            | 20GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 200 Concurrent Connections. Postgres Version 10. DB Instance Class: db.t2.small.        | paid |
|#  medium-10              | 100GB Storage, Dedicated Instance, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.large.                         | paid |
|#  medium-ha-10           | 100GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 500 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.large.       | paid |
|#  large-10               | 512GB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.2xlarge.                      | paid |
|#  large-ha-10            | 512GB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.2xlarge.    | paid |
|#  xlarge-10              | 2TB Storage, Dedicated Instance, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.4xlarge.                        | paid |
|#  xlarge-ha-10           | 2TB Storage, Dedicated Instance, Highly Available, Storage Encrypted, Max 5000 Concurrent Connections. Postgres Version 10. DB Instance Class: db.m4.4xlarge.      | paid |

### Current analysis

In [#167839682](https://www.pivotaltracker.com/n/projects/1275640/stories/167839682) we had a look
at the usage on our existing databases and concluded that, for the most part, the existing plans are
appropriate for current usage. We didn't identify any databases that could easily have been on a
smaller instance size if only it had higher IOPS (which was one hypothesis).

There was some evidence in the form of support tickets that our current small plans don't have
enough IOPS, causing people to prematurely upgrade to mediums.  AWS warn you against creating DBs
with less than 100G disk due to IOPS restrictions, so it seems sensible that we shouldn't provided
plans smaller than that.

At the moment, prices for postgres 10.5 Tiny, Small and Medium instances are:

| plan      | price / month |
|-----------|---------------|
|# tiny      | £12.03        |
|# small     | £24.50        |
|# small-ha  | £48.98        |
|# medium    | £125.94       |
|# medium-ha | £251.79       |

If we were to increase the disk size on small instances from the current 2G to 100G, this would
cause the small plans to increase roughly as follows (based on Ireland prices):

| plan      | price / month       |
|-----------|---------------------|
|# tiny      | £12.03              |
|# small     | £34.40 (was £24.50) |
|# small-ha  | £67.88 (was £48.98) |
|# medium    | £125.94             |
|# medium-ha | £251.79             |

We have about 100 "small" databases, of which 28 are HA and 70 are not. This means if we changed the
disk on the existing plans our tenants would have to pay an extra £1,200/month (but on the flip
side, they might be able to stick with small plans for longer, because of the better IOPS).

Alternatively we could add a new pair of plans like "small-high-iops" and "small-ha-high-iops".
This would allow an upgrade path of `small -> small-high-iops -> medium`, instead of the current
`small -> medium`, which would avoid people paying for CPU and memory they don't need.

Separately, we should add support for postgres 11 and mysql 8, which are both supported by RDS now.
For these new plans we should use the newest available instance types (so t3 / m5 instead of t2 /
m4).

Decision
--------

### Create new plans for postgres 11

We should play [a story to add the following new plans](https://www.pivotaltracker.com/story/show/168322288):

| service plan          | summary                                                     |
|-----------------------|-------------------------------------------------------------|
|# tiny-unencrypted-11   | 5GB Storage, NOT BACKED UP. DB Instance Class: db.t3.micro. |
|# small-11              | 100GB Storage. DB Instance Class: db.t3.small.              |
|# small-ha-11           | 100GB Storage. DB Instance Class: db.t3.small.              |
|# medium-11             | 100GB Storage. DB Instance Class: db.m5.large.              |
|# medium-ha-11          | 100GB Storage. DB Instance Class: db.m5.large.              |
|# large-11              | 512GB Storage. DB Instance Class: db.m5.2xlarge.            |
|# large-ha-11           | 512GB Storage. DB Instance Class: db.m5.2xlarge.            |
|# xlarge-11             | 2TB Storage. DB Instance Class: db.m5.4xlarge.              |
|# xlarge-ha-11          | 2TB Storage. DB Instance Class: db.m5.4xlarge.              |

(note: t3 / m5 instances, small plans have 100G storage instead of 20G)

### Create new plans for mysql 8

We should play [a story to add the following new plans](https://www.pivotaltracker.com/story/show/168322475):

| service plan       | summary                                          |
|--------------------|--------------------------------------------------|
|# tiny-unencrypted-8 | 5GB Storage. DB Instance Class: db.t3.micro.     |
|# small-8            | 100GB Storage. DB Instance Class: db.t3.small.   |
|# small-ha-8         | 100GB Storage. DB Instance Class: db.t3.small.   |
|# medium-8           | 100GB Storage. DB Instance Class: db.m5.large.   |
|# medium-ha-8        | 100GB Storage. DB Instance Class: db.m5.large.   |
|# large-8            | 512GB Storage. DB Instance Class: db.m5.2xlarge. |
|# large-ha-8         | 512GB Storage. DB Instance Class: db.m5.2xlarge. |
|# xlarge-8           | 2TB Storage. DB Instance Class: db.m5.4xlarge.   |
|# xlarge-ha-8        | 2TB Storage. DB Instance Class: db.m5.4xlarge.   |

(note: t3 / m5 instances, small plans have 100G storage instead of 20G)

### Create new "small-high-iops" and "small-ha-high-iops" plans, for mysql 5.7, postgres 9.5 and 10

We should play [a story to add "High IOPS" plans for the existing postgres / mysql versions](https://www.pivotaltracker.com/story/show/168322617).

These should have 100G of storage and be on the `t3.small` instance type (since there's no reason to
be adding new plans on old instance types).

This story may turn out not to be a priority.

### Do not change the instance types for the existing plans

We considered whether to upgrade existing databases to new m5 / t3 instances, or to make it so that
new databases on old versions (i.e. postgres 9.5 / 10, mysql 5.7) get latest-generation instance
types.

We decided not to do this because it would be tricky to administer the change, and it's nice to have
the new instance types as an incentive for people to upgrade.

Status
------

Accepted

Consequences
------------

* Small databases for the newer engine versions (postgres 11 / mysql 8) will be more expensive and
  have more disk.
* Some tenants may be able to stick with small databases for longer before they have to upgrade to
  the medium plan, saving them money.
* Tenants will be able to get higher performing databases by using the newest engine versions
  (postgres 11 / mysql 8).
* It will be possible for us to implement "downgrading" from `medium` to `small` databases for the
  new plans in the broker (since they have the same sized disks) - this could save tenants money if
  they optimise their database usage and discover they could move from a `medium` to a `small`.
* We will have 9 to 11 more plans for postgres and mysql.

