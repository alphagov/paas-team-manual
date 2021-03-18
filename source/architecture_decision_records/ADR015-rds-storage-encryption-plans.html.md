---
title: ADR015 - RDS storage encryption plans
---

# ADR015: RDS storage encryption plans

## Context

We want to enable, or provide the option to enable,
[storage encryption (AKA encryption at rest) for the RDS instances](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html)
of the tenants databases created by our [RDS broker](https://github.com/alphagov/paas-rds-broker). The broker has logic to enable this option on creation.

But there are [some limitations](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html#Overview.Encryption.Limitations):

 * Storage Encryption can only be enabled on creation of the DB. There is no way to update an instance to enable or disable encryption. The only way is by creating a encrypted (or unencrypted) copy of a snapshot, to then restore it to a DB instance.
 * <s>Storage Encryption is only supported [for some instance types](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html#d0e47573). Specifically it is not supported for `db.t2.small` and `db.t2.micro.`, used in our Small and Free plans</s>
 * Update 2018-01-24: Amazon have now [enabled support for encryption of `t2` instances](https://aws.amazon.com/about-aws/whats-new/2017/06/amazon-rds-enables-encryption-at-rest-for-additional-t2-instance-types/).

In consequence:

  * Users cannot migrate from a plan with encryption (Medium or Large) to a plan without encryption (Small or Free). But this use case is less common.
  * Users can migrate from Free/Small to a plan with encryption (Medium or Large), but the instance will not have encryption enabled.
  * If we enable encryption in the existing plans, the existing databases will remain without encryption.
  * Due the API broker limitations, it is not possible to query the attributes of an existing instance.

We have 3 options to proceed:

 1. Enable Encryption in the Medium and Large plans, and document the restrictions.
    * Less effort to implement.
    * We might end having unencrypted database in a plan that is meant to be encrypted, which is confusing for the users and operators.
    * Existing Instances will remain unencrypted.
 2. Change the instance type for the Small plan to `db.m3.medium`.
    * Would allow migrate from Small to Medium or Large.
    * We will still have the problem for the Free plan.
    * Increases the costs for the Small plan (double).
 3. Provide additional explicit plans with Encryption enabled, and keep the old ones. Add logic to prevent updates between plans with or without encryption.
    * It would be more explicit and clear, and the plan would match the state of the existing database.
    * Existing instances would still match with the plan description.
    * We will add more plans, which makes it more confusing for the tenants.


## Decision

We decided to provide additional explicit plans with Encryption enabled, and keep the old ones.

We will add logic in the broker to prevent updates between plans with or without encryption.

We have decided only add the option of encryption to the HA plans to minimise the number of new plans added. In most of the cases the tenants would choose HA together with encryption and, although adding more plans is easy, removing them is painful once they are being used.

## Status

Accepted.

## Consequences

 * More plans will be added to the offer, which is more confusing the tenants. Better documentation would be required to help the tenants to pick the right plan.
 * It is not possible to migrate from a Non-Encrypted plan to an Encrypted plan, and vice versa.


