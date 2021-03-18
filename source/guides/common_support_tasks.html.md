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
