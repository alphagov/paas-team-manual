---
title: Applying tenant ElastiCache service updates
---

# Applying tenant ElastiCache service updates

We provide [Redis](https://redis.io) to our users via
[AWS ElastiCache](https://aws.amazon.com/elasticache/).

Periodically there are
[service updates](https://aws.amazon.com/elasticache/elasticache-maintenance/#:~:text=Service%20updates%20is%20a%20feature,operational%20performance%20of%20your%20clusters.)
which need to be applied to tenant ElastiCache service instances.

For highly available service instances, downtime will be limited, but for
non-highly available instances, there may be some downtime (up to 30 minutes).

## When should we upgrade

Depending on the update, it might be more or less important to upgrade.
AWS emails PaaS Support when updates are available.

We may also wish to schedule an update when many instances have an update
available. You can determine this percentage with the Prometheus query:

```
count(paas_aws_elasticache_cluster_update_required)
/
count(paas_aws_elasticache_replication_group_nodes_count)
```

## Caveats

Updates are currently still applied manually (via the Console or the API) and
we do not have a process in place for applying the updates automatically.

## Process outline

1. Create a Pivotal story to track the lifecycle of the upgrade

1. Pick a maintenance window within working hours (the updates are applied manually, and we do not expect anyone to do them outside working hours), e.g. Tuesday 16th June 2020 between 09:00-11:00

1. For each production region, repeat the following steps:

  1. Log in to CF `cf login --sso` as a Global Auditor or Admin

  1. Find which instances need to be updated:

            AWS_REGION=eu-west-1 gds aws paas-prod -- \
            ./tools/aws_redis_update_manager/aws_redis_update_manager \
            --action print \
            --paas-accounts-url https://accounts.cloud.service.gov.uk \
            --paas-accounts-username admin \
            --paas-accounts-password "$( echo get this from credhub under /prod-lon/prod-lon/secrets_paas_accounts_admin_password ; exit 1 )"

  1. Send a preview email to yourself:

            AWS_REGION=eu-west-1 gds aws paas-prod -- \
            ./tools/aws_redis_update_manager/aws_redis_update_manager \
            --action preview \
            --notify-api-key "$( echo make a key or get from credhub ; exit 1)" \
            --maintenance-window-date 'Tuesday 16 June 2020' \
            --maintenance-window-time-range '0900-1100' \
            --region Ireland \
            --preview-email 'your@email.here'

  1. Send the email to tenants:

            AWS_REGION=eu-west-1 gds aws paas-prod -- \
            ./tools/aws_redis_update_manager/aws_redis_update_manager \
            --action email \
            --paas-accounts-url https://accounts.cloud.service.gov.uk \
            --paas-accounts-username admin \
            --paas-accounts-password "$( echo get this from credhub under /prod-lon/prod-lon/secrets_paas_accounts_admin_password ; exit 1 )" \
            --notify-api-key "$( echo make a key or get from credhub ; exit 1)" \
            --maintenance-window-date 'Tuesday 16 June 2020' \
            --maintenance-window-time-range '0900-1100' \
            --region Ireland \
            --preview-email 'your@email.here'

1. Schedule maintenance on the
   [GOV.UK PaaS status page](https://status.cloud.service.gov.uk)
   for the two maintenance windows, without sending notifications.

1. If a tenant replies to the email asking to delay/skip the update, record their preference in the story.

1. During the maintenance window, follow
   [the AWS guidance on applying service updates](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/applying-updates.html), skipping any instances recorded in the previous step. You will have to do this in both regions.
