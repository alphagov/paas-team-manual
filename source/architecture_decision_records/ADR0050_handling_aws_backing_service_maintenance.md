# ADR0050: Handling AWS-based backing service maintenance

## Status

Proposal

## Context

### Technology 

We have two types of backing service provided by AWS (Postgres and MySQL databases via RDS, and Redis instances via Elasticache) which have periodic maintenance and patches applied to them by AWS. These updates require the instance owner (us) to either

- acknowledge and trigger the application of update, or
- wait until the deadline has passed, at which point AWS will apply the update at an unknown point during a window. 

Historically, we have done the latter. For high-availability (HA) service instances, application of these updates should result in very little downtime (perhaps a couple of minutes) as the services fail over to the standby instances. However, non-HA instances can experience downtime measuring up to half an hour.

Today, we don't have a consistent, low-effort way of handling these updates and/or communicating them to the tenants who own the service instances.

For these services (RDS and Elasticache), AWS has quite a comprehensive and detailed set of features for managing these updates, but the team agrees that we don't want to 

- try to expose the full power of this interface to tenants programmatically, or 
- become the human proxies of these features to our tenants.

Both service types have a concept of a "maintenance window", a time period when most maintenance will be scheduled to take place. This time period is selectable in AWS, but we only currently expose this configurability to tenants in the RDS broker. Only very critical updates will be force-applied in this maintenance window. For less critical updates, we (the PaaS team) receive a notification that a new piece of maintenance needs to take place, and we can then make a choice as to when the maintenance occurs. 

For RDS, one choice is to perform it in the next maintenance window. This is the lowest effort choice to make, and the one we expect most tenants would make most of the time. However, we don't feel that asking tenants for each update is a scalable solution given the team size today; we have over 800 databases in the London region alone, and we could feasibly find ourselves with a lot of communication to do to a lot of tenants, many of whom will have further questions or want boutique actions taken. As a result, most of the lower priority updates sit in our "TODO" pile indefinitely and eventually get force-applied by AWS at the end of their acceptable deferral period. This is far from ideal, and is arguably as disruptive as applying all mandatory updates in the first available maintenance window, as maintenance packages will eventually be reaching the end of their deferrable period at approximately same rate as new ones appear. RDS also has non-mandatory maintenance updates, which in theory can be deferred indefinitely, but these don't seem to have been common lately.

There are a couple of relevant differences between RDS and Elasticache in how maintenance works:

 - Elasticache doesn't have the ability to set an item of maintenance to be performed in the next available maintenance window. Maintenance can be applied immediately, applied "automatically after the due date" (see below), or ignored (for non-mandatory updates). To achieve the same ability as RDS we'd have to run our own cron-based trigger to launch maintenance at the right time.

 - Elasticache allows maintenance to be applied automatically in the maintenance window following an issue's "due date" (which is a date a certain number of weeks after its announcement, based on the severity of the issue). There doesn't seem to be an equivalent of this in RDS.

 - Elasticache publishes a list of the fleet-wide maintenance items that are currently happening through an AWS console page and an API, where RDS only tends to notify us on a per-database level, which would be slightly trickier to aggregate and deduplicate for easy tenant consumption.

 - Elasticache "maintenance" items sometimes include bumps of redis version, sometimes bumps with user-visible results - e.g. redis 6.0 -> 6.2 which actually changes the instance's reported "engine version". These tend to be non-mandatory though.

 - Elasticache's mandatory updates appear to have a maximum possible deferral of around 90 days, whereas it's not uncommon to see RDS mandatory updates that are a year late.

These issues outline a need for us to present a radically simplified self-service interface to maintenance for tenants in the same way we present a radically simplified interface to various AWS services in general. As such it *will not* give tenants all the fine grained control over maintenance, but arguably a large part of PaaS' remit is to guard tenants from a lot of the maintenance decisions involved in directly running a cloud service.

It would also be beneficial to make the mechanisms for both services operate in as similar a manner as possible (externally and internally) to reduce the amount of mental load for support staff.

### Organisation

This ADR and the discussions surrounding it took place over the first half of 2022, during a period when the GOV.UK PaaS team was waiting for a decision from GDS senior leadership about the future of the platform. Ultimately, [they decided to decomission the platform by the end of 2023](https://gds.blog.gov.uk/2022/07/12/why-weve-decided-to-decommission-gov-uk-paas-platform-as-a-service/). This decision gave the team pause for thought about the maintenance burden we felt it was appropriate to put upon tenants, for whom platform decomissioning will cause significant amounts of migration work.

## Decision

The brokers for Postgres, MySQL, and Redis service instances should automatically apply any maintenance updates that meet the following criteria:

1. an update will not potentially introduce breaking changes (i.e. exclude major version upgrades),
2. an update is mandatory, and would be applied by Amazon themselves at some point,
3. an update can be scheduled in this way.

For the Elasticache broker in particular, we will create a regular background job which triggers the immediate application of maintenance updates during a service instance's maintenace period. 

The Elasticache broker will also need need to allow tenants to

* get details like the current maintenance window when they do `cf service`

* set the maintenance window for service instances via `cf update-service` in a way very similar to, if not identical to, the RDS broker

Both brokers will need a mechanism for disabling maintenance updates on service instances. Given the impending decomissioning of the platform, we feel that building this out in a self-service mannner could be unnecessarily burdonsome. Having a list of identifiers in a config file which we update in response to tenant tickets would likely suffice.

We expect this new update behaviour to have the same impact as our historic behaviour of allowing the updates to be applied at the end of a deferral period. We will have to consider what we want to tell tenants, because on the one hand this probably won't affect them, but on the other hand we're adding new functionality for a backing service type.

We are aware that some tenants have had issues with extended periods of downtime when a Redis instance fails over, and that our decision will cause Redis failovers more frequently. The remediation for this issue is known, but out of scope for this ADR.

## Consequences

 - We would be able to safely ignore the vast majority of maintenance notification messages we receive, which are frequently overwhelming, are hard to manage and we currently have no clear policy on handling.

 - Tenants will appear to experience more frequent downtime in their maintenance window. This is mitigated by highly-available service plans.

 - The periodic jobs run by our brokers would have to be carefully designed not to exceed API rate-limits given the number of instances we manage. There may be a temptation to use cached values to help with this, but this would likely result in surprising behaviour when values are changed shortly before a maintenance window.
