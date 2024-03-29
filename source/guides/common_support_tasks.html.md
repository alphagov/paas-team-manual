---
title: Common support tasks
---

# Common support tasks

This guide contains instructions for common support tasks.


## Changing a user's password

1. Set your AWS environment variables to the production environment
   (assuming this is a production user)
2. Log into the cf client with an "admin" user.
3. Set your `DEPLOY_ENV` environment variable to `prod`
4. Run `./paas-cf/scripts/create-user.sh -r -e user@example.com`

The script will mark the user as "unverified" and send a new invite
link, which essentially will be a new password.

## Subscribe and check the AWS notifications

AWS [sends notifications to our maillists](/team/responding_to_aws_alert/). You should subscribe to these groups to get any notification.

## Notifying all users

Occasionally you may need to notify all users of an event on the platform, perhaps during an incident in progress or to send an incident report.

To do this, follow the instructions on [notifying tenants](/team/notifying_tenants/).

## Uncontactable Org Managers

If none of the org managers for a specific org are contactable (for example if they've all left) then the following people within the team are permitted to approve the nomination of another person to be org manager:

- Product Manager
- Delivery Manager
- Technical Architect

Factors in their decision:

- if the org is used for trial/prototyping or live use
- if they are able to make contact with other senior members of the team to whom the org belongs
- if the email account belonging to the absent org manager can be made active again to send an email authorising the change.

We will also email every user currently in the organisation to explain what has been done.


# Common Support questions

## Which databases do you support?

- [Postgres](https://admin.cloud.service.gov.uk/marketplace/efadb775-58c4-4e17-8087-6d0f4febc489) (RDS)
- [MySQL](https://admin.cloud.service.gov.uk/marketplace/8ffb13cb-705f-4cee-9ffd-5a950f9f3048) (RDS)
- [Opensearch](https://admin.cloud.service.gov.uk/marketplace/c8181636-dfcf-48f9-8c9a-7da3fbf0aafc)
- [Redis](https://admin.cloud.service.gov.uk/marketplace/0e4b6fb6-243c-4024-8604-41635d1233cc)
- [Influxdb](https://admin.cloud.service.gov.uk/marketplace/0b7da7a9-2fd7-4dca-9e25-0cf8eddd0f88)

## Some plans in the marketplace are displaying as free. What does this mean?

This is a horrible bit of Cloud Foundry user interface: "free" really means "free for 3 months while you are in trial, and then you need to pay."


## Can I get direct access to the RDS database instances?

No – the high level abstraction of the GOV.UK PaaS hides the details of the database inside the PaaS service.

## What is your Opensearch offering?
We currently offer [Opensearch](https://admin.cloud.service.gov.uk/marketplace/b98f53e7-85a7-4964-bace-9ce27fac142a)

## What is the status of the Opensearch backing service?
GOV.UK PaaS is a [live service](https://www.gov.uk/service-standard-reports/gov-dot-uk-platform-as-a-service-paas-live-assessment)
