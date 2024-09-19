---
title: Production London Decommissioning
---

# Production London Decommissioning

## Introduction

The purpose of this document is to provide a guide for decommissioning the production environment in London after the Ireland production environment has been decommissioned.

This is only a guide, and is based on the steps outlined on [the Ireland decommissioning page](../ireland_decomissioning). There are likely steps missing and the process may need to be adapted as you go.

## Pre-checks

Before starting the decommissioning process, ensure that the following checks have been completed:

- [ ] Ensure all tenants have been migrated off the environment.
- [ ] Ensure all final bills have been sent. Decommissioning the environment will stop the billing process.
- [ ] Ensure logit graphs do not show any traffic to the environment other than the normal platform traffic.
- [ ] Ensure all user applications have been removed or stopped.
- [ ] Ensure all user services have been removed from the environment. PaaS services will be removed as part of the decommissioning process. [The pipeline script](https://github.com/alphagov/paas-cf/blob/main/scripts/unbind-and-delete-all-services.sh) will try to remove all services, however it may fail if a service is not ready for removal (For example, if an s3 bucket is not empty).

## Before decommissioning

Before decommissioning the environment, ensure that the following steps have been completed:

- [ ] Take a pg_dump of the billing database and store somewhere safe. We will have a final rds snapshot as well, but it is good to have a backup in case we have post-decommissioning billing queries.
- [ ] Take a pg_dump of the audit database and store somewhere safe. This contains all the cf events since the auditor was deployed.
- [ ] Remove [all peers from the terrraform config](https://github.com/alphagov/paas-cf/blob/main/terraform/prod-lon.vpc_peering.json). Set to [] to ensure removal. Merge and deploy.

## Decommissioning PaaS London

- [ ] Extract pingdom credentials [from paas-credentials](https://github.com/alphagov/paas-credentials/tree/main/pingdom.com). Log into pingdom and remove the London checks.
- [ ] Remove [protection for the prod-lon environment](https://github.com/alphagov/paas-cf/blob/main/scripts/unbind-and-delete-all-services.sh#L51). Merge to main. 
- [ ] Add '$(eval export ENABLE_DESTROY=true)' [to prod-lon section in paas-cf Makefile](https://github.com/alphagov/paas-cf/blob/3efbd129cd1b6914f75a2391d35ab701cf8774a9/Makefile#L320). Merge to main.
- [ ] Announce on #cyber-security-notifications (slack) using 'Action Notification' your intention to decommission the environment. Getting team member approval.
- [ ] Run `gds aws paas-prod-admin -- make prod-lon pipelines` to push the destroy pipeline to concourse.
- [ ] Start the 'destroy-cloudfoundry' pipeline [from concourse](https://deployer.cloud.service.gov.uk/)
    - Note: It is likely the terraform destroy might fail on s3 buckets. They may need to be manually emptied and concourse job re-run. It is also an option to add force_destroy to the terraform if it is missing.

= DO NOT CONTINUE UNTIL THE DESTROY PIPELINE HAS COMPLETED SUCCESSFULLY =

- [ ] Add `$(eval export ENABLE_DESTROY=true)` to the prod-lon section [in paas-bootstrap Makefile](https://github.com/alphagov/paas-bootstrap/blob/5be4d2f09635d2d51200206a5f1cc33e41766bba/Makefile#L139). Merge to main.
- [ ] Spin up a production london vagrant vm with `gds aws paas-prod-admin -- make prod-lon deployer-concourse bootstrap`
- [ ] Start `destroy-bosh-concourse pipeline` from the vagrant machine concourse. Ensure this runs to completion successfully.
- [ ] Remove vagrant vm with `gds aws paas-prod-admin -- make prod-lon deployer-concourse bootstrap-destroy`


## Post Decommissioning Checks

- [ ] Click around AWS console and enable the resource explorer in Ireland to look for orphaned items. Check:
    - [ ] ec2
    - [ ] ebs
    - [ ] ebs snapshots
    - [ ] elbs
    - [ ] cloudfront (remember this is global, it won't be empty so check with care)
    - [ ] s3 (remember is this global, check with care). Prod-lon state bucket will still probably be there and can now be removed.
    - [ ] rds
    - [ ] rds snapshots (we expect to still have snapshots)
    - [ ] sqs
    - [ ] eips
    - [ ] amis (Bosh might have left a few amis). Clean up.
    - [ ] cloudwatch
    - [ ] elasticache redis caches
- [ ] Check aiven project "paas-cf-prod". Ensure we don't have any services beginning with "prod-lon-".
- [ ] Check AWS billing in the following days to see we aren't being charged for anything unexpected in the London region.

- [ ] Database snapshots will no longer automatically time out. We will need to remove them all once we are happy we don't need them. Leave for a few weeks to be sure before cleanup.


## Post Decommissioning Clean Up

- [ ] Archive documentation as needed. This includes:
    - [ ] [team-manual](https://github.com/alphagov/paas-team-manual)
    - [ ] [product-pages](https://github.com/alphagov/paas-product-pages)
    - [ ] [paas-tech-docs](https://github.com/alphagov/paas-tech-docs)
- [ ] Archive the [paas-credentials](https://github.com/alphagov/paas-credentials) repository.
- [ ] Remove PaaS people from the [GDS PagerDuty config](https://github.com/alphagov/gds-pagerduty-config)
