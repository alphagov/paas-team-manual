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
