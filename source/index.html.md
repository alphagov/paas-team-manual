# PaaS Team Manual

## Incident and support model

 - [Incident process](incident_management/incident_process/)
 - [Support manual](incident_management/support_manual/)
 - [Support roles and responsibilities](incident_management/roles_and_responsibilities/)
 - [Service Targets](team/service_targets/)

## Support Runbook
### Response
 - [Responding to alerts](support/responding_to_alerts/)
 - [Responding to security issues](support/responding_to_security_issues/)
 - [Responding to AWS alerts](team/responding_to_aws_alert/)

### How-to
 - [How to do common support tasks](guides/common_support_tasks/)
 - [How to do user and organisation management](support/CF_UAA_user_management/)
 - [How to use GPG](guides/GPG/)
 - [How to enable Github OAuth for your dev environment](guides/Github_oAuth_in-Dev/)
 - [How to sign into your CF admin account](guides/cf_admin_users/)
 - [How to connect to Concourse, Credhub, and BOSH](guides/Connecting_to_Concourse_CredHub_and_BOSH/)
 - [How to set up VPC Peering](guides/vpc_peering/)
 - [How to upgrade CF, bosh and stemcells](guides/upgrading_CF,_bosh_and_stemcells/)
 - [How to update Logstash filters in Logit](guides/editing_logstash_filters/)
 - [How to view our data in splunk](support/viewing_our_data_in_splunk/)
 - [How to find route owners](support/finding_route_owners)
 - [How to find apps with noisy logging](support/finding_apps_with_noisy_logging)
 - [How to find activity](support/finding_activity/)
 - [How to restore Elasticsearch backups](support/restoring_elasticsearch_backups/)
 - [Shipping Elasticsearch metrics to our tenants](support/shipping_elasticsearch_metrics_to_tenants/)
 - [How to apply tenant ElastiCache (redis) service updates ](support/tenant_elasticache_service_updates/)
 - [How to restore the CF databases](guides/Restoring_the_CF_databases/)
 - [How to restore the bosh director](guides/restoring_bosh_director/)
 - [How to release bosh blobs](guides/releasing_bosh_blobs/)
 - [How to run `paas-cf` tests locally](guides/running_paas-cf_tests_locally/)
 - [How to rotate credentials](team/rotating_credentials/)

### Other information
 - [Our orgs on the paas](team/our_orgs_on_the_paas/)
 - [Debugging IPSec](guides/IPSec_debugging/)
 - [Enhancing Kibana](guides/enhancing_kibana/)
 - [Investigating Rsyslog issues](support/rsyslog/)
 - [Cloud Foundry debugging tips](guides/CloudFoundry_debugging/)
 - [Tenant application penetration testing](guides/Tenant_Application_Penetration_Testing/)
 - [Spruce (for merging YAML)](guides/spruce/)
 - [Effective remote pairing](guides/effective_remote_pairing/)
 - [Platform alerting](team/platform_alerting/)

## Tenant Account Management
 - [Account lifecycle](accounts/account_lifecycle)
 - [Getting data about trial accounts](accounts/getting_data_about_trial_accounts/)
 - [Tenant personal data](accounts/tenant_personal_data/)

## Tenant Billing
 - [Billing process for GOV.UK PaaS paid accounts](accounts/billing_info)

## Team Accounts and Software
 - [Zendesk](support/zendesk/)
 - [Statuspage](team/statuspage/)
 - [Pagerduty](team/pagerduty/)
 - [Documentation for tenants (`paas-tech-docs`)](guides/Documentation_system/)
 - [Third parties cloud accounts](team/managing_access_to_cloud_services/)

## Policies and Procedures
### Team process
 - [Orientation](team/orientation/)
 - [Dashboard mac mini](team/dashboard_mac_mini/)
 - [How to notify tenants](team/notifying_tenants/)
 - [Comms lead role](team/comms_lead_role/)

### Working practices
 - [Development process](team/working_practices/#development-process)
 - [Development Stories](team/working_practices/#stories)
 - [Tech doc changes](team/working_practices/#stories)

## Technical Design
 - [Audit](monitoring_alerting/audit)
 - [BOSH](technical_design/bosh)
 - [GOV.UK PaaS Architecture Document](https://docs.google.com/document/d/1bNL2wi0hdqv_fpdcI4LMNxpU_KpqoB_YI_z-7RWOutI/edit#heading=h.m1yfz0hmgd73) (team visibility)
 - [Prometheus](technical_design/prometheus)
 - [Networking in AWS](technical_design/networking_in_aws/)

### Styleguides

  This section contains some team-specific styleguides. These should be used in
  addition to the [GDS styleguides]().

  [GDS styleguides]: https://github.com/alphagov/styleguides/

   - [YAML](styleguides/YAML/)
   - [Concourse pipelines](styleguides/concourse_pipeline/)

## Architecture decision records

This section contains Architecture Decision Records (ADR) as described in this blog post <http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions>.

 - [ADR-001 Manifest management](architecture_decision_records/ADR001-manifest-management/)
 - [ADR-002 Concourse pool resource](architecture_decision_records/ADR002-concourse-pool-resource/)
 - [ADR-003 AWS credentials](architecture_decision_records/ADR003-AWS-credentials/)
 - [ADR-004 Domain naming scheme](architecture_decision_records/ADR004-domain-naming-scheme/)
 - [ADR-005 Pingdom healthchecks](architecture_decision_records/ADR005-pingdom-healthchecks/)
 - [ADR-006 Rds broker](architecture_decision_records/ADR006-rds-broker/)
 - [ADR-007 Terminating tls at elbs](architecture_decision_records/ADR007-terminating-tls-at-elbs/)
 - [ADR-008 HAProxy for request rewriting](architecture_decision_records/ADR008-haproxy-for-request-rewriting/)
 - [ADR-009 X-Forwarded headers](architecture_decision_records/ADR009-x-forwarded-headers/)
 - [ADR-010 Postgres bind behaviour](architecture_decision_records/ADR010-postgres-bind-behaviour/)
 - [ADR-011 Security group structure](architecture_decision_records/ADR011-security-group-structure/)
 - [ADR-012 Haproxy healthcheck](architecture_decision_records/ADR012-haproxy-healthcheck/)
 - [ADR-013 Building bosh releases](architecture_decision_records/ADR013-building-bosh-releases/)
 - [ADR-014 Hsts preload using api gateway](architecture_decision_records/ADR014-hsts-preload-using-api-gateway/)
 - [ADR-015 Rds storage encryption plans](architecture_decision_records/ADR015-rds-storage-encryption-plans/)
 - [ADR-016 End to end encryption](architecture_decision_records/ADR016-end-to-end-encryption/)
 - [ADR-017 Cell capacity assignment](architecture_decision_records/ADR017-cell-capacity-assignment/)
 - [ADR-018 Rds broker restore last operation](architecture_decision_records/ADR018-rds-broker-restore-last-operation/)
 - [ADR-019 Accessing user provided services](architecture_decision_records/ADR019-accessing-user-provided-services/)
 - [ADR-020 Deletion of ci environment](architecture_decision_records/ADR020-deletion_of_ci_environment/)
 - [ADR-021 Cell capacity assignment 2](architecture_decision_records/ADR021-cell-capacity-assignment-2/)
 - [ADR-022 Web app language and framework selection](architecture_decision_records/ADR022-web_app_language_and_framework_selection/)
 - [ADR-023 Idle cpu alerting change](architecture_decision_records/ADR023-idle-cpu-alerting-change/)
 - [ADR-024 Web app language and framework selection](architecture_decision_records/ADR024-web-app-language-and-framework-selection-2/)
 - [ADR-025 Service plan naming conventions](architecture_decision_records/ADR025-service-plan-naming-conventions/)
 - [ADR-026 DNS layout for UK hosting](architecture_decision_records/ADR026-DNS-layout-for-UK-hosting/)
 - [ADR-027 Pipeline locking](architecture_decision_records/ADR027-pipeline-locking/)
 - [ADR-028 Move platform logs to Logit](architecture_decision_records/ADR028-move-logs-to-logit/)
 - [ADR-029 Aiven project structure](architecture_decision_records/ADR029-aiven-project-structure/)
 - [ADR-030 Single staging environment in London](architecture_decision_records/ADR030-single-staging-london/)
 - [ADR-031 Separate PaaS services from the Platform core pipeline](architecture_decision_records/ADR031-services-core-pipeline-separate-jobs)
 - [ADR-032 SSL only for applications and cf endpoints](architecture_decision_records/ADR032-ssl-only-for-applications-and-cf-endpoints/)
 - [ADR-033 Redirect http for applications](architecture_decision_records/ADR033-redirect-http-for-applications/)
 - [ADR-034 Continuously deploy platform CF applications](architecture_decision_records/ADR034-continuously-deploy-platform-cf-apps/)
 - [ADR-035 Do not use HAProxy, use AWS ALB](architecture_decision_records/ADR035-do-not-use-haproxy-use-aws-alb/)
 - [ADR-036 Add new RDS broker plans](architecture_decision_records/ADR036-add-new-rds-broker-plans/)
 - [ADR-037 Automated certificate rotation](architecture_decision_records/ADR037-automated-certificate-rotation/)
 - [ADR-038 Audit logs in Splunk](architecture_decision_records/ADR038-audit-logs-in-splunk/)
 - [ADR-039 Provide Aiven metrics to users](architecture_decision_records/ADR039-aiven-metrics-for-users/)
 - [ADR-040 BOSH access without SOCKS](architecture_decision_records/ADR040-bosh-access-without-socks/)
 - [ADR-041 BOSH access with mTLS](architecture_decision_records/ADR041-bosh-access-with-mtls/)
 - [ADR-042 Isolation segments](architecture_decision_records/ADR042-isolation-segments/)
 - [ADR-043 New product pages language and framework selection](architecture_decision_records/ADR043-new-product-pages-language-and-framework/)
