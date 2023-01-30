---
title: Close billable accounts
---

# Close billable accounts

This process describes how we close accounts as tenants migrate off the GOV.UK PaaS platform.

A closed account:

- is unusable by the tenant (no cf push, cf start, cf stop or cf scale)
- has no services or data
- has no applications
- is flagged as suspended
- has no users associated with the Cloud Foundry org
- incurs no costs to us
- exists as an empty shell in Cloud Foundry

## Accounts closure process

1. Tenant (an org manager or billing manager) confirms that they are ready to close their org account with us.
2. Support engineer performs all technical decommissioning tasks.
 - Suspend org (`scripts/suspend-org.sh ${ORG_NAME}` in `paas-cf`)
 - Remove all users from the org
 - Delete all backing services
 - Delete all apps
 - Spaces can be left alone, because they don’t incur a cost
3. Support engineer confirms the date when tasks in step 2 were completed, e.g. *“emptied and suspended <date>”* in column E of the Trial and billable accounts tab in [GOV.UK PaaS usage and adoption tracker - 2020-07-06](https://docs.google.com/spreadsheets/d/1bZP7W-5nJxDicJ2lc_eT873zXXjXnHh-qGYJobHUIv8/edit#gid=40753783) 
4. Support engineer replies to the tenant confirming the date of “closure”. **For external tenants**: Inform GDS Business Operations (PMO) of the tenant's closure date by CC-ing them into the ticket (GDS Business Operations or PMO).
5. Mark the ticket as SOLVED.
