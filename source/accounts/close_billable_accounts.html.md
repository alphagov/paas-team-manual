---
title: Close billable accounts
---

# Close billable accounts

This process describes how we close accounts as tenants migrate off the GOV.UK PaaS platform.

A closed account:

- is unusable by the tenant (no `cf push`, `cf start`, `cf stop` or `cf scale`)
- has no services or data
- has no applications
- has no users associated with the Cloud Foundry org
- is flagged as suspended
- incurs no costs to us
- exists as an empty shell in Cloud Foundry

## Accounts closure process

1. Tenant (an org manager or billing manager) confirms that they are ready to close their org account with us.
2. Support engineer performs all technical decommissioning tasks.
 - Suspend the org (`scripts/suspend-org.sh ${ORG_NAME}` in `paas-cf`)
 - Check if the org is ready for decommissioning (`scripts/get-decommissioning-details.sh ${ORG_NAME}` in `paas-cf`)
 - Delete all backing services (for each S3 bucket, delete all bucket contents (see [connect to and S3 bucket from outside of GOV.UK PaaS](https://docs.cloud.service.gov.uk/deploying_services/s3/#connect-to-an-s3-bucket-from-outside-of-the-gov-uk-paas) for the guidance on getting creds to use with the [AWS CLI](https://aws.amazon.com/cli/)))
 - Delete all apps (`cf delete -rf`)
 - Delete all spaces (`cf delete-space`)
 - Remove all users from the org ([`scripts/decommission_organisation.rb`](https://github.com/alphagov/paas-cf/blob/main/scripts/decommission_organisation.rb)  in `paas-cf`)
3. In [GOV.UK PaaS - Tenant migration tracker](https://docs.google.com/spreadsheets/d/1LFxVqSfZ7fH7PDF-mh57M-X1fLUdmR770a-JfPCp9k8/edit#gid=1195828254) find the organisation name in "Service Status Summary" tab and
 - Set 'decommissioned' status in column H
 - Add link to the Zendesk account closure request ticket to column M
 - Update the `column P` (service_count) number to 0
 - Update `column Q`  with the decomission date
4. Reply to the tenant confirming the date of “closure”.
5. Mark the ticket as SOLVED.
6. **For external tenants**: send an email to the GDS Business Operations PMO team inbox: <pmo@digital.cabinet-office.gov.uk>, Craig Goodwin: <craig.goodwin@digital.cabinet-office.gov.uk> and Humira Akuji: <humira.akuji@digital.cabinet-office.gov.uk>, with the following details:

```
Email subject: GOV.UK PaaS tenant account closed: [insert org name]
Email text:
"The PaaS team have closed the above tenant's account. Please arrange for the final invoice to be sent to them:
Org name:
Date org closed:"
```

>PMO team will pursue outstanding bills and if not paid by the tenant after 5 attempts, where it is deemed all avenues have been exhausted, they will escalate for a final decision to the PaaS Service Owner via the Delivery Manager.
