# ADR0050: Handling AWS-based backing service maintenance

## Status

Proposal

## Context

We have two types of backing service provided by AWS (RDS databases and Elasticache redis instances) that have a similar problem - when AWS need to perform maintenance on service instances we don't have a consistent, low-effort way of handling this and/or communicating this to the user. For high-availability (HA) service instances, application of these maintenance packages should result in very little downtime (perhaps a couple of minutes) as the services fail over to the standby instances. The bigger threat to uptime is from a poorly configured application failing to respect the DNS TTL and continuing to attempt connecting to the "old" IP of the service.

For these services, AWS has quite a comprehensive and detailed set of features for managing these updates, but we all tend to agree that the last thing we want to do is either:

 - try to expose the full power of this interface to tenants programmatically
 - become the human proxies of these features to our tenants

Both service types have a concept of a "maintenance window", a time period when most maintenance will be scheduled to take place. This time period is selectable in AWS, but we only currently expose this configurability to tenants in the RDS broker.

Only very critical updates will be force-applied in this maintenance window. For less critical updates, we (the PaaS team) receive a notification that a new piece of maintenance needs to take place, and we can then make a choice as to when the maintenance occurs. For RDS, one of these choices is to perform it in the "next maintenance window". The problem with this though is we have over 800 databases in the London region alone, and the people who are best placed to know when's best to apply these updates are tenants. So we can find ourselves with a lot of communication to do to a lot of tenants, many of whom will have further questions or want boutique actions taken. In short, it's a support bomb. As a result, most of the lower priority updates sit in our "TODO" pile indefinitely and eventually get force-applied by AWS at the end of their acceptable deferral period. This is far from ideal, and is arguably as disruptive as applying all mandatory updates in the first available maintenance window, as maintenance packages will eventually be reaching the end of their deferrable period at approximately same rate as new ones appear, just **many** months late. RDS also has non-mandatory maintenance updates, which in theory can be deferred indefinitely, but these don't seem to have been common lately.

There are a couple of relevant differences between RDS and Elasticache in how maintenance works:

 - Elasticache doesn't have the same ability to set an item of maintenance to be performed in the next available maintenance window. Maintenance can be applied immediately, applied "automatically after the due date" (see below), or ignored (for non-mandatory updates). To achieve the same ability as RDS we'd have to run our own cron-based trigger to launch maintenance at the right time.
 - Elasticache allows maintenance to be applied automatically in the maintenance window following an issue's "due date" (which is a date a certain number of weeks after its announcement, based on the severity of the issue). There doesn't *seem* to be an equivalent of this in RDS. As long as we're not intending to grant tenants the ability to choose to apply a specific piece of maintenance "early" at an opportune moment, it's not clear what advantage this would have for us - unless perhaps it meant lower-priority maintenance could be coalesced with higher-priority maintenance and result in less overall downtime. There's also the possibility it could be used as a substitute for the missing "apply in next maintenance window" feature.
 - Elasticache publishes a list of the fleet-wide maintenance items that are currently happening through an AWS console page and an API, where RDS only tends to notify us on a per-database level, which would be slightly trickier to aggregate and deduplicate for easy tenant consumption.
 - Elasticache "maintenance" items sometimes include bumps of redis version, sometimes bumps with user-visible results - e.g. redis 6.0 -> 6.2 which actually changes the instance's reported "engine version". These tend to be non-mandatory though.
 - Elasticache's mandatory updates appear to have a maximum possible deferral of around 90 days, whereas it's not uncommon to see RDS mandatory updates that are a year late.

These issues outline a need for us to present a radically simplified self-service interface to maintenance for tenants in the same way we present a radically simplified interface to various AWS services in general. As such it *will not* give tenants all the fine grained control over maintenance, but arguably a large part of PaaS' remit is to guard tenants from a lot of the maintenance decisions involved in directly running a cloud service.

It would also be beneficial to make the mechanisms for both services operate in as similar a manner as possible (externally and internally) to reduce the amount of mental load for support staff.

## Decision

Both brokers should be provided with the following features:

 - The ability to set a service instance's maintenance window. The RDS broker already allows this.
 - A periodic job that will trigger available maintenance for a managed service instance in its maintenance window. The Elasticache broker would need a job that ran *at least* every hour to guarantee running within any possible maintenance window (which can be minimum 1 hour wide) because Elasticache lacks the ability to set maintenance to run in the "next maintenance period". There would be advantages to using this technique in the RDS broker too - use of the "apply at next maintenance window" feature means there's a time period *between* then and the start of that maintenance period where it's too late to stop a piece of maintenance using the flag described below. Using our own broker to schedule the maintenance avoids this danger. The RDS broker already has a "cron" mechanism which it uses for deleting old snapshots. Note that the minimum maintenance window for an RDS instance is half an hour, meaning our periodic job would need to run twice as frequently.
 - A flag on service instances that would allow the above "eager maintenance" feature to be turned off. A tenant might want to use this flag when they have a particularly busy or critical period approaching for their service. Using this would give them an "update holiday", which the periodic job would catch up on missed maintenance. Tenants that were extremely averse to updates could leave this flag off permanently, which would result in something close to the current situation - important updates being force-applied by AWS after the maximum deferral period.
 This flag could also have a third setting, which would allow the tenant to only apply "mandatory" maintenance eagerly.
 The default value for this flag is open for discussion, though leaving eager updates "off" by default would fail to solve the bulk of the problem. "Eager maintenance" is probably most useful to tenants who aren't attentive enough to discover this flag and turn it on.

As a stretch goal, we could devise a mechanism to communicate upcoming maintenance to tenants, though this has some significant caveats:

 - The more tenants see about these updates, the more likely we are to get boutique support requests for special handling of their service instance and information on whether a specific update has been applied to their service.
 - If we publish this information in a general, whole-platform way, (easy for Elasticache, much harder for RDS), we leave tenants to figure out for themselves which maintenance item applies to each of their instances.
 - If we push this information to them, per-instance, we're just passing on the noise to them that we ourselves find so hard to handle. We also don't have a great way of targeting the relevant users - we tend to email org managers, which, in large organizations, can be a very blunt tool.

## Consequences

 - We would be able to safely ignore the vast majority of maintenance notification messages we receive, which are frequently overwhelming, are hard to manage and we currently have no clear policy on handling.
 - Through manipulation of these two new controls (maintenance window and "eager maintenance" flag), quite a few behaviours could be achieved - for example, a tenant wanting "immediate" application of maintenance ahead of a busy period could temporarily move their service instance's maintenance window to an hour in the future and turn on eager maintenance.
 - Assuming eager maintenance is enabled, tenants will appear to experience more frequent downtime in their maintenance window. With "eager maintenance" set to "mandatory only" the increased maintenance frequency would only be an illusion because of the way newly-created services currently unintentionally experience a "grace period" of very little/no maintenance until the first mandatory updates have caught up with them after many months.
 - In those cases where there *is* an increased frequency of maintenance, tenants with HA services will sooner discover that their apps aren't designed to handle a DNS-switched failover properly.
 - The "severity" of an Elasticache maintenance item would effectively be lost as a means by which to differentiate its' handling. We would class updates as either mandatory or non-mandatory. This could be seen as a necessary model simplification.
 - The periodic jobs run by our brokers would have to be carefully designed not to exceed API rate-limits given the number of instances we manage. There may be a temptation to use cached values to help with this, but this would likely result in surprising behaviour when values are changed shortly before a maintenance window.
