# Process for closing GOV.UK PaaS trial accounts

This process describes how we close old trial accounts to retain historical billing data and prevent infrastructure bills running up.

A closed account:

  - is unusable by the tenant (no `cf push`, `cf start`, `cf stop` or `cf scale`)
  - has no services or data 
  - has no applications 
  - is flagged as suspended
  - has no users associated with the Cloud Foundry org
  - incurs no costs to us
  - exists as an empty shell in Cloud Foundry

![A state diagram showing the possible routes for tenants adopting the paas](/diagrams/process-for-closing-old-trial-accounts.svg)

| Sequence | Title | Description | Max time |
|:---|:---|:---|:---|
|1|New tenant|A new tenant that does not have a PaaS account yet|Indefinitely|
|2|Trial|A tenant with a 90 day trial account with the ability to deploy apps and provision small backing services|90 days|
|3|Billable|A full tenant with a billing arrangement that is being recharged for the resource consumed|Indefinitely|
|4|Suspended|The org is suspended and the tenant will not be able to perform any operations on apps or services.<br /><br />Users will be able to use the apps. Tenants will be able to log in to Cloud Foundry.|30 days|
|5|Halted|The apps are stopped and users will receive '404' error messages from the platform.<br /><br />The data is preserved and the account will still run up bills for the databases|30 days|
|6|Removed|The application instances and services are deleted by an operator.<br /><br />Users will see no difference compared to a halted/stopped app, but the tenant will have to re-push the app and re-create any backing services to restore their apps.<br /><br />At this point the account cannot incur any billable events and the bill goes to zero.<br /><br />All app, services and data are unavailable.|Indefinitely|

![BAU trial account expiry process](/diagrams/BAU-trial-account-expiry-process-map.svg)


## Accounts closure process

1. Review trial organisations<br />
  - [in the London region](https://admin.london.cloud.service.gov.uk/reports/organisations)
  - [in the Ireland region](https://admin.cloud.service.gov.uk/reports/organisations)
  - Look for accounts that are 2.5 months in to their 3 month trial period, and still on the trial quota.
1. Update the [backlog list of potential accounts](https://docs.google.com/spreadsheets/d/1bZP7W-5nJxDicJ2lc_eT873zXXjXnHh-qGYJobHUIv8/edit#gid=527069954) for closure (in PaaS adoption tracker).
1. Keep track of [potential accounts for closure](https://docs.google.com/spreadsheets/d/1bZP7W-5nJxDicJ2lc_eT873zXXjXnHh-qGYJobHUIv8/edit#gid=949444725) in the tracker while contacting org managers.
1. Keep track of [closed accounts and cost savings](https://docs.google.com/spreadsheets/d/1bZP7W-5nJxDicJ2lc_eT873zXXjXnHh-qGYJobHUIv8/edit#gid=159027804) by adding each trial account to the tracker.
1. Notify tenant (via [zendesk macro](https://docs.google.com/document/d/1shOo7PSvWh2CqxSEzqW8Q4OyRCAW3g7xrSGQ9foRfAA/edit#heading=h.v5ekyyl9lqs3) saying the trial account is past the 3 month period and give 2 weeks notice that we will suspend the account state 4 (Suspended). [Macros definition](https://docs.google.com/document/d/1shOo7PSvWh2CqxSEzqW8Q4OyRCAW3g7xrSGQ9foRfAA/edit#)
1. If tenant confirms they intend to keep using their account, they need to [switch to billable](https://team-manual.cloud.service.gov.uk/accounts/account_lifecycle/#upgrading-trial-orgs-to-paid-orgs) - support engineer and DM to help (track via zendesk).
If tenant says they don’t want the account, go to state 6 (Removed).
1. If no response from tenant after 2 weeks grace period the support engineer suspends the account - State 4 (Suspended). To suspend use `cf curl -X PATCH -d '{"suspended": true}' "/v3/organizations/$(cf org <ORG-TO-BE-SUSPENDED> --guid)"`
1. Notify the tenant that their trial account has been suspended and they have 30 days to tell us they need the account. Make it clear that after this timeframe, we will stop their apps running, but keep their data State 5 (Halted).
1. If tenant responds, they need to [switch to billable](https://team-manual.cloud.service.gov.uk/accounts/account_lifecycle/#upgrading-trial-orgs-to-paid-orgs) - support engineer and DM to help (track via Zendesk).
If tenant says they don’t want the account, go to state 6 (Removed).
1. If no response from tenant, after the 30 day grace period the support engineer stops apps running state 5 (Halted).
1. Notify the tenant via Zendesk that we have stopped their apps services.
1. Pull billing data associated with the trial account and save in [PaaS team folder] (https://drive.google.com/drive/folders/1aq0gSOrDS1EGsq0aEx4dIOYEmy9j5dJL).
1. Notify tenant via Zendesk that in 30 days we will delete any data and all of their apps.
1. If no response from tenant, after the 30 day grace period the support engineer deletes all apps and services, and removes users - org state 6 (removed).
1. Support engineer confirms that they have deleted apps and services in [tracker](https://docs.google.com/spreadsheets/d/1bZP7W-5nJxDicJ2lc_eT873zXXjXnHh-qGYJobHUIv8/edit#gid=159027804) [column H].
1. Record cost saving and date of closure in tracker.
