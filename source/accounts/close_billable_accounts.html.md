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
 - Remove all users from the org ([`scripts/decommission_organisation.rb`](https://github.com/alphagov/paas-cf/blob/main/scripts/decommission_organisation.rb)  in `paas-cf`)
 - Delete all backing services
 - Delete all apps
 - Spaces can be left alone, because they don’t incur a cost
3. In [GOV.UK PaaS - Tenant migration tracker](https://docs.google.com/spreadsheets/d/1LFxVqSfZ7fH7PDF-mh57M-X1fLUdmR770a-JfPCp9k8/edit#gid=1195828254) find the organisation name in "Service Status Summary" tab and 
 - Add link to the Zendesk account closure request ticket to column M
 - Update the `column P` (service_count) number to 0
 - Update `column Q`  with the decomission date
4. Reply to the tenant confirming the date of “closure”. **For external tenants**: Inform GDS Business Operations (PMO) of the tenant's closure date by CC-ing them into the ticket (GDS Business Operations or PMO).
5. Mark the ticket as SOLVED.
