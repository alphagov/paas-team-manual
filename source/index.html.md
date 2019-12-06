# PaaS Team Manual

## Incident management

 - [Incident process](incident_management/incident_process/)
 - [Responding to alerts](incident_management/responding_to_alerts/)

## Monitoring and alerting

- [Prometheus](monitoring_alerting/prometheus)

## Support

 - [User management](support/CF_UAA_user_management/)
 - [Finding activity](support/finding_activity/)
 - [Finding route owners](support/finding_route_owners)
 - [Finding apps with noisy logging](support/finding_apps_with_noisy_logging)
 - [Restoring Elasticsearch Backups](support/restoring_elasticsearch_backups/)
 - [Responding to security issues](support/responding_to_security_issues/)
 - [Support roles and responsibilities](support/roles_and_responsibilities/)
 - [Investigating rsyslog issues](support/rsyslog/)
 - [Support manual](support/support_manual/)
 - [Zendesk](support/zendesk/)

## Accounts and Billing

 - [Account lifecycle](accounts/account_lifecycle)
 - [Getting data about trial accounts](accounts/getting_data_about_trial_accounts/)
 - [Tenant personal data](accounts/tenant_personal_data/)
 - [Billing process for GOV.UK PaaS paid accounts](accounts/billing_info)

## Team

 - [Orientation](team/orientation/)
 - [Working practices](team/working_practices/)
 - [Service Targets](team/service_targets/)
 - [Dashboard mac mini](team/dashboard_mac_mini/)
 - [Managing access to Cloud Services](team/managing_access_to_cloud_services/)
 - [Our networking in AWS](team/networking_in_aws/)
 - [How to notify tenants](team/notifying_tenants/)
 - [Our orgs on the paas](team/our_orgs_on_the_paas/)
 - [Pagerduty](team/pagerduty/)
 - [Platform alerting](team/platform_alerting/)
 - [Responding to aws alert](team/responding_to_aws_alert/)
 - [Rotating credentials](team/rotating_credentials/)
 - [Statuspage](team/statuspage/)

## Guides

 - [Cloud Foundry debugging tips](guides/CloudFoundry_debugging/)
 - [Connecting to Concourse and BOSH](guides/Connecting_to_Concourse_and_BOSH/)
 - [Documentation for tenants (`paas-tech-docs`)](guides/Documentation_system/)
 - [How to use GPG](guides/GPG/)
 - [How to enable Github OAuth for your dev environment](guides/Github_oAuth_in-Dev/)
 - [IPSec debugging](guides/IPSec_debugging/)
 - [Restoring the CF databases](guides/Restoring_the_CF_databases/)
 - [Tenant Application Penetration Testing](guides/Tenant_Application_Penetration_Testing/)
 - [How to sign into your CF admin account](guides/cf_admin_users/)
 - [Common support tasks](guides/common_support_tasks/)
 - [Enhancing kibana](guides/enhancing_kibana/)
 - [Releasing bosh blobs](guides/releasing_bosh_blobs/)
 - [Spruce (for merging YAML)](guides/spruce/)
 - [upgrading CF, bosh and stemcells](guides/upgrading_CF,_bosh_and_stemcells/)
 - [Updating Logstash filters in Logit](guides/editing_logstash_filters/)
 - [VPC Peering](guides/vpc_peering/)
 - [Running tests on `paas-cf` locally](guides/running_paas-cf_tests_locally/)
 - [Restoring the bosh director](guides/restoring_bosh_director/)
 - [Effective remote pairing guidance](guides/effective_remote_pairing/)

### Styleguides

This section contains some team-specific styleguides. These should be used in
addition to the [GDS styleguides]().

[GDS styleguides]: https://github.com/alphagov/styleguides/

 - [YAML](styleguides/YAML/)
 - [Concourse pipelines](styleguides/concourse_pipeline/)

## Architecture decision records

This section contains Architecture Decision Records (ADR) as described in this blog post <http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions>.

 - [ADR001 manifest management](architecture_decision_records/ADR001-manifest-management/)
 - [ADR002 concourse pool resource](architecture_decision_records/ADR002-concourse-pool-resource/)
 - [ADR003 AWS credentials](architecture_decision_records/ADR003-AWS-credentials/)
 - [ADR004 domain naming scheme](architecture_decision_records/ADR004-domain-naming-scheme/)
 - [ADR005 pingdom healthchecks](architecture_decision_records/ADR005-pingdom-healthchecks/)
 - [ADR006 rds broker](architecture_decision_records/ADR006-rds-broker/)
 - [ADR007 terminating tls at elbs](architecture_decision_records/ADR007-terminating-tls-at-elbs/)
 - [ADR008 haproxy for request rewriting](architecture_decision_records/ADR008-haproxy-for-request-rewriting/)
 - [ADR009 x forwarded headers](architecture_decision_records/ADR009-x-forwarded-headers/)
 - [ADR010 postgres bind behaviour](architecture_decision_records/ADR010-postgres-bind-behaviour/)
 - [ADR011 security group structure](architecture_decision_records/ADR011-security-group-structure/)
 - [ADR012 haproxy healthcheck](architecture_decision_records/ADR012-haproxy-healthcheck/)
 - [ADR013 building bosh releases](architecture_decision_records/ADR013-building-bosh-releases/)
 - [ADR014 hsts preload using api gateway](architecture_decision_records/ADR014-hsts-preload-using-api-gateway/)
 - [ADR015 rds storage encryption plans](architecture_decision_records/ADR015-rds-storage-encryption-plans/)
 - [ADR016 end to end encryption](architecture_decision_records/ADR016-end-to-end-encryption/)
 - [ADR017 cell capacity assignment](architecture_decision_records/ADR017-cell-capacity-assignment/)
 - [ADR018 rds broker restore last operation](architecture_decision_records/ADR018-rds-broker-restore-last-operation/)
 - [ADR019 accessing user provided services](architecture_decision_records/ADR019-accessing-user-provided-services/)
 - [ADR020 deletion of ci environment](architecture_decision_records/ADR020-deletion_of_ci_environment/)
 - [ADR021 cell capacity assignment 2](architecture_decision_records/ADR021-cell-capacity-assignment-2/)
 - [ADR022 web app language and framework selection](architecture_decision_records/ADR022-web_app_language_and_framework_selection/)
 - [ADR023 idle cpu alerting change](architecture_decision_records/ADR023-idle-cpu-alerting-change/)
 - [ADR024 web app language and framework selection](architecture_decision_records/ADR024-web-app-language-and-framework-selection-2/)
 - [ADR025 Service plan naming conventions](architecture_decision_records/ADR025-service-plan-naming-conventions/)
 - [ADR026 DNS layout for UK hosting](architecture_decision_records/ADR026-DNS-layout-for-UK-hosting/)
 - [ADR027 pipeline locking](architecture_decision_records/ADR027-pipeline-locking/)
 - [ADR028 Move platform logs to Logit](architecture_decision_records/ADR028-move-logs-to-logit/)
 - [ADR029 Aiven project structure](architecture_decision_records/ADR029-aiven-project-structure/)
 - [ADR030 single staging environment in London](architecture_decision_records/ADR030-single-staging-london/)
 - [ADR443 ssl only for applications and cf endpoints](architecture_decision_records/ADR443-ssl-only-for-applications-and-cf-endpoints/)
 - [ADR444 redirect http for applications](architecture_decision_records/ADR444-redirect-http-for-applications/)
 - [ADR445 continuously deploy platform CF applications](architecture_decision_records/ADR445-continuously-deploy-platform-cf-apps/)
 - [ADR446 do not use HAProxy, use AWS ALB](architecture_decision_records/ADR446-do-not-use-haproxy-use-aws-alb/)
 - [ADR447 add new RDS broker plans](architecture_decision_records/ADR447-add-new-rds-broker-plans/)
 - [ADR448 automated certificate rotation](architecture_decision_records/ADR448-automated-certificate-rotation/)
 - [ADR449 audit logs in Splunk](architecture_decision_records/ADR449-audit-logs-in-splunk/)
 - [ADR450 provide Aiven metrics to users](architecture_decision_records/ADR450-aiven-metrics-for-users/)
