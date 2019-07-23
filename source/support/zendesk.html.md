# Zendesk guide

Teaching the wider Zendesk interface is out-of-scope of this guide, but it records key things in our usage.

We use the [GOV.UK Zendesk](https://govuk.Zendesk.com/agent/filters) for managing support tickets and some automated notifications.

We have two sorts of tickets: ordinary support dealt with in-hours, and P1 incidents dealt with out-of-hours. We have an extra view for ordinary tickets requiring attention from the product people.

There are multiple inputs for ordinary support tickets: forms on the product page, emails to the `gov-uk-paas-support@digital.cabinet-office.gov.uk` address, automated CVE alerts, etc.

To bring tickets to the attention of PaaS product people, add the `govuk_paas_product_support` tag.

A few people in the team have edit permissions over our own views, but for most changes we need to talk to the GDS support team within TechOps. Open a Zendesk ticket assigned to `2nd/3rd Line--Zendesk Administration`.

Email notifications of incoming tickets are administered manually. This needs doing when someone is added or removed from Zendesk. Contact the support team.

## Routing

The in-hours email address `gov-uk-paas-support@digital.cabinet-office.gov.uk` is given in numerous places, for instance our [Support](https://www.cloud.service.gov.uk/support) page. The out-of-hours email address is deliberately not written down in public, to avoid spam waking people up at night.

Both email addresses are Google Groups. Originally we used Gmail Aliases but they did not support prepending to email subjects for Zendesk. These groups forward emails elsewhere and are not intended for use by themselves. Their spam protection is disabled to avoid emails being silently discarded.

The in-hours email address prepends `[PaaS Support]` to email subjects, and forwards it to a Zendesk email address. The out-of-hours email address prepends `[PaaS Emergency Support]` and also forwards to a PagerDuty email address.

## Tagging

We use the following tags to categorise support tickets:

<div style="height:1px;font-size:1px;">&nbsp;</div>

| Category | Tag |
|:---|:---|
| Incident Report (cf) | govuk_paas_incident_report_cf_performance_issues |
| Incident Report (cf) | govuk_paas_incident_report_cf_availability |
| Incident Report (cf) | govuk_paas_incident_report_cf_deployment |
| Incident Report (cf) | govuk_paas_incident_report_cf_downtimes |
| Incident Report (tenant) | govuk_paas_incident_report_t_performance_issues |
| Incident Report (tenant) | govuk_paas_incident_report_t_availabilty |
| Incident Report (tenant) | govuk_paas_incident_report_t_deployment |
| Incident Report (tenant) | govuk_paas_incident_report_t_downtimes |
| Backing services | govuk_paas_backing_services_monitoring_metrics_logs |
| Backing services | govuk_paas_backing_services_binding_unbinding_issues |
| Backing services | govuk_paas_backing_services_private_beta_access |
| Backing services | govuk_paas_backing_services_connecting_issues |
| Backing services | govuk_paas_backing_services_postgres |
| Backing services | govuk_paas_backing_services_mysql |
| Backing services | govuk_paas_backing_services_redis |
| Backing services | govuk_paas_backing_services_elasticsearch |
| Backing services | govuk_paas_backing_services_cdn |
| Backing services | govuk_paas_backing_services_performance |
| Backing services | govuk_paas_backing_services_scaling |
| Notifications | govuk_paas_notifications_security_cve |
| Notifications | govuk_paas_notifications_aws_notifications |
| Notifications | govuk_paas_notifications_upstream_notifications |
| Apps | govuk_paas_apps_monitoring_metrics_logs |
| Apps | govuk_paas_apps_deployment |
| Apps | govuk_paas_apps_certificates |
| Apps | govuk_paas_apps_buildpacks |
| Apps | govuk_paas_apps_secrets |
| Apps | govuk_paas_apps_performance |
| Apps | govuk_paas_apps_scaling |
| Apps | govuk_paas_apps_scheduling |
| Account Management | govuk_paas_account_management_user_addition |
| Account Management | govuk_paas_account_management_user_removal |
| Account Management | govuk_paas_account_management_user_password_reset |
| Account Management | govuk_paas_account_management_quota_increase |
| Account Management | govuk_paas_account_management_sla |
| Account Management | govuk_paas_account_management_organisation_account_management |
| Account Management | govuk_paas_account_management_domain_management |
| Account Management | govuk_paas_account_management_billing |
| Bug Report | govuk_paas_bug_report_cli |
| Bug Report | govuk_paas_bug_report_backing_services |
| Bug Report | govuk_paas_bug_report_documentation_error |
| Engagement Request | govuk_paas_engagement_request_trial_account |
| Engagement Request | govuk_paas_engagement_request_new_account_enquiry |
| Engagement Request | govuk_paas_engagement_request_contact_request |
| Engagement Request | govuk_paas_engagement_request_onboarding_request |
| Engagement Request | govuk_paas_engagement_request_pricing |
| Engagement Request | govuk_paas_engagement_request_sla |
| Security | govuk_paas_security_pen_test |
| Security | govuk_paas_security_information_assurance |
| Security | govuk_paas_security_authentication |
| Security | govuk_paas_security_secrets |
| Security | govuk_paas_security_access_control |
| Security | govuk_paas_security_infrastructure |
| Security | govuk_paas_security_domain_management |
| Feature / Query | govuk_paas_feature_query_IP_networking |
| Feature / Query | govuk_paas_feature_query_capability_question |
| Feature / Query | govuk_paas_feature_query_infrastructure |
| Feature / Query | govuk_paas_feature_query_domain_management |
| Feature / Query | govuk_paas_feature_query_untagged |
| Feature / Query | govuk_paas_feature_query_plugins |
| Misc | govuk_paas_misc_non_technical |
| Misc | govuk_paas_difficult_to_tag |

<div style="height:1px;font-size:1px;">&nbsp;</div>
