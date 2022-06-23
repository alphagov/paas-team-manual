# So you're on support for GOV.UK Platform as a Service (PaaS)

Welcome to the GOV.UK PaaS support rota!

Do not panic.
Your task is to monitor platform health and support channels, not to solve everything yourself!
Always feel free to involve the team if you get stuck at any point.

## Before you go on support

### Make sure you can connect to our environments and access the relevant secrets

If you’re in the office and have a GDS-issued Mac, you must connect to the Brattain WiFi endpoint. This should happen automatically. If you have any issues with connecting, visit the IT Helpdesk. If you are using a bring-your-own device (BYOD), you must  [connect to the VPN](https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit).

If you’re outside the office, you must [connect to the VPN](https://docs.google.com/document/d/1O1LmLByDLlKU4F1-3chwS8qddd2WjYQgMaaEgTfK5To/edit).

If you have a private static IP, you can ask the tech leads to add it to an allow list that allows access to GOV.UK PaaS production resources (but not other GDS AWS accounts, such as the billing account).

During the onboarding process, you should have been given full access as defined in the [paas-trusted-people repository](https://github.com/alphagov/paas-trusted-people/blob/main/users.yml). If you find any access missing, contact your onboarding buddy or the person who worked on the story, and ask them to grant you access.

The paas-trusted-people repository should also contain:

* a [GNU Privacy Guard (GPG)](https://team-manual.cloud.service.gov.uk/guides/GPG/#install) public key with signature and encryption functionality 
* an SSH public key
* your Google ID for OAuth

Your onboarding buddy should have added your GPG key to the paas-credentials repository and added also it for [merge signing](https://team-manual.cloud.service.gov.uk/team/working_practices/#manually-merging-and-signing-a-pr) of pull requests in these repositories:

* [paas-admin](https://github.com/alphagov/paas-admin)
* [paas-bootstrap](https://github.com/alphagov/paas-bootstrap)
* [paas-cf](https://github.com/alphagov/paas-cf)



If you find any access missing or have any questions or concerns, contact your onboarding buddy or the person who worked on the story, and ask them to grant you production access.

### Make sure you have access to our Zendesk views

To reply to support tickets on [Zendesk](https://govuk.zendesk.com/), you will need:
 
* your role to be ‘GDS Resolver’
* to be a member of the ‘3rd-line-- PaaS Support’ Zendesk team  

Someone else with access should request these permissions for you by raising a Zendesk ticket assigned to the 2nd/3rd Line Zendesk Administration group.

### Make sure PagerDuty is set up correctly

GDS should have issued you a work phone when you joined. Speak to your line manager if you do not have one. You should install the PagerDuty app on your work phone to allow you to resolve incidents through the app.

You will need a PagerDuty account and to be a member of the /tech-ops/GOV.UK PaaS Team - a tech lead or Delivery Manager can organise this for you.

You will need to add in your contact information and edit your notification rules in your PagerDuty profile (reached through the avatar on the top right on the PagerDuty app or through **My Profile** on the web UI).

If you use Do Not Disturb mode on your phone, make sure PagerDuty is able to ring through it (check your phone OS docs to set this up). You can also set up the PagerDuty app to override Do Not Disturb mode.


### Make sure you have access to our alerts mailing lists

You need to join these [Google Groups](https://groups.google.com):

* GOV.UK PaaS Support
* GOV.UK PaaS Emergency Support
* govpaas-alerting-prod

### Make sure you have access to Slack

You need to join the following Slack channels on gds.com:

* [#paas-internal](https://gds.slack.com/archives/CAEHMHGJ2)
* [#paas-incident](https://gds.slack.com/archives/CAD4W35KK)
* [#paas](https://gds.slack.com/archives/CADHV9267) 

You also need to join the following Slack channels on  ukgovernmentdigital.slack.com:

*  [#govuk-paas](https://ukgovernmentdigital.slack.com/archives/C33SAH4GJ)
* [#govuk-paas-dit-users](https://ukgovernmentdigital.slack.com/archives/CN26120NR)  

## Do some shadowing 

When you join the team, the DM or tech lead should arrange the following: 

* shadowing support shifts 8 weeks after joining the team
* 2 weeks shadowing the person on support

They should also arrange reverse shadowing for your first 2 weeks on support, with a more experienced engineer helping and supporting you. 

Speak to your line manager or the tech lead if you have any questions or concerns about your shadowing experience. 

## Going on support

### Update the Slack channel topics with your username

You should set the Slack channel topic to “[@your_slack_username] is on support” on the following channels:

* [#paas](https://gds.slack.com/archives/CADHV9267) on GDS Slack
* [#govuk-paas](https://ukgovernmentdigital.slack.com/?redir=%2Farchives%2FC33SAH4GJ) on cross-government Slack 


## After going on support

At the end of your support shift, you need to:

* make sure all ongoing support tasks are sufficiently documented in Zendesk and/or hand over work to the person coming onto the support rota
* claim for your on-call shift using the [GaaP and CEVPS on-call pay submission form](https://docs.google.com/forms/d/e/1FAIpQLSfpMK85F2CxBFo_uubO2HHintc3Gx6jbifeUhnAm0g6GfoDEA/viewform?vc=0&c=0&w=1&flr=0)

## Support times

* in-hours: Weekdays 9:00 - 17:00
* out-of hours: Weekdays 17:00 - 9:00, weekends 24/7

You should regularly check the [dynamic calendar showing your in-hours support shifts as defined in PagerDuty](https://calendar.google.com/calendar/ical/8nvffdghj1kfrfgmji0ottc8nnh52t37%40import.calendar.google.com/public/basic.ics).

## Communication channels and dashboards to be aware of

### Zendesk

We’re working off the ‘PaaS Support’ view. To reach this, select **Views** in the menu bar on the left hand side of the Zendesk web UI.

### Slack

We receive tenant communications through:

* [#paas](https://gds.slack.com/archives/CADHV9267) on GDS Slack
* [#govuk-paas](https://ukgovernmentdigital.slack.com/archives/C33SAH4GJ) and [#govuk-paas-dit-users](https://ukgovernmentdigital.slack.com/archives/CN26120NR) on cross-government Slack

You should also keep an eye on the following channels in case any incidents come through:

* [#paas-internal](https://gds.slack.com/archives/CAEHMHGJ2)
* [#paas-incident](https://gds.slack.com/archives/CAD4W35KK)

You should also monitor your direct messages. If a tenant DMs you when you’re not on the rota, it’s up to you if you want to help them. It’s perfectly fine to point them in the direction of the current support person.

### Grafana dashboards

We use [Grafana](https://grafana.com/oss/grafana/) to monitor platform metrics. We use a mixture of dashboards shipped with Cloud Foundry and dashboards developed by the GOV.UK PaaS team. On support, a good starting point is to monitor:

* [User impact dashboard for Ireland](https://grafana-1.cloud.service.gov.uk/d/paas-user-impact/user-impact-prod?orgId=1&refresh=5s)
* [User impact dashboard for London](https://grafana-1.london.cloud.service.gov.uk/d/paas-user-impact/user-impact-prod-lon?orgId=1&refresh=5s)

If the AZ hosting `grafana-1` is affected by an incident or the prometheus in that AZ is non-functional or missing data, you can use [`grafana-2`](/technical_design/prometheus#high-availability) and its fully-redundant monitoring stack instead.

### Deployment pipelines for staging and production

We use [Concourse](https://concourse-ci.org/) for our continuous integration and continuous deployment (CI/CD) pipelines. The Concourse instances important for GOV.UK PaaS production are:

* [Deployer Concourse for our staging environment](https://deployer.london.staging.cloudpipeline.digital/)
* [Deployer Concourse for our Ireland production environment](https://deployer.cloud.service.gov.uk/)
* [Deployer Concourse for our London production environment](https://deployer.london.cloud.service.gov.uk/)
* [Continuous integration Concourse for our production environments](https://concourse.build.ci.cloudpipeline.digital/)

### Mailing lists

We receive a number of platform alerts as well as tickets submitted through the Zendesk CRM as emails as well. To keep up-to-date during your in-hours support shift, you should regularly check your inbox for messages from:

* [govpaas-alerting-prod@digital.cabinet-office.gov.uk](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/govpaas-alerting-prod)
* [gov-uk-paas-support@digital.cabinet-office.gov.uk](https://groups.google.com/a/digital.cabinet-office.gov.uk/g/gov-uk-paas-support)
