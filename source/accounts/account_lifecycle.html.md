# Account lifecycle

## Definition of trial organisation

When a team starts using GOV.UK PaaS, they get to try out the platform for 3 months using a trial organisation. With this account, the team can:

- manage users
- create and manage spaces
- deploy and run apps
- use trial-sized editions of our backing services

The trial period is free of charge, but users are only allowed a capped quota of resources, cannot set up custom domains and cannot run production apps on the platform.

## Creating new trial organisations

An existing tenant or someone new to the platform can request a trial
organisation at [https://www.cloud.service.gov.uk/signup][signup]. This
triggers an automated Zendesk ticket to support. The applicant will need an
official (gov.uk) email address to use this form.

If a request comes in outside Zendesk (for example via email), the person
receiving the request should raise a Zendesk ticket by sending an email to
[gov-uk-paas-support@digital.cabinet-office.gov.uk][support email].

We need to know the following information before setting up a trial account:

- Name of the Government Department or Public body
- The name of an individual who will act as the Organisation Manager
- Some information about the proposed service.

If this information is not provided or is unclear, PaaS Support should clarify
with the requester.

PaaS Support should then check whether an organisation is Crown or non-Crown
(see the Engagement Team’s [CRM][engagement team's CRM]).

If the organisation is Crown and the requester has a gov.uk email address, PaaS
Support must set up the trial organisation on a default quota, confirm this to
the organisation via Zendesk, and cc a PaaS Product Manager and the relevant
engagement lead from [this document](https://docs.google.com/document/d/13qGTlbQfqhH-Gx46e2w2XJKG4JyBnnFWLWJgM2XxUAc/edit).

If the organisation is Crown and the requester does not have a gov.uk email
address, PaaS Support must ask the requester to supply an individual with a
gov.uk address to act as the organisation manager.

If the organisation is non-Crown, a trial organisation is available at the
discretion of the PaaS Product Manager, who should be contacted via an internal
note on Zendesk. As of November 2018 we can offer non-Crown bodies a trial
organisation, but when setting it up we must include the following note:

> Currently, non-Crown bodies are able to trial the GOV.UK PaaS but cannot
provide live services on it. We expect to be able to fully service non-Crown
bodies by January 2019.

GOV.UK PaaS Support must define the name of the organisation in a way that
identifies the department and the service, for example defra-cleanair.

Once GOV.UK PaaS Support has set up the trial organisation on a default quota,
GOV.UK PaaS Support must confirm this to the organisation via Zendesk, and cc a
Product Manager. It is then the responsibility of the Product Manager to liaise
with the [Engagement team][engagement team email] to ensure they are aware of
the new organisation. If the Department does not have a Memorandum of
Understanding (see the Engagement Team’s [CRM][engagement team's CRM]), then
the Product Manager must check with the Engagement Team whether they are in the
process of getting one signed. Getting an MOU signed is the remit of the
Engagement Team, not the PaaS team.

## Upgrading trial organisations to paid organisations

### Requests to upgrade

Requests to upgrade from a trial to a paid organisation can come from multiple sources: e.g. Zendesk, email, the engagement team. Regardless of the source, the same process applies:
Zendesk ticket and tenant confirmation

To keep track in Zendesk and get the tenant to confirm the pricing:

1. A Zendesk ticket must be raised by either the tenant, engagement team or the GOV.UK PaaS team.
2. GOV.UK PaaS support picks up this ticket and tags it as ‘govuk_paas_trial_upgrade’ in Zendesk to track it.
3. In the Zendesk ticket, cc in the organisation managers and billing managers in the organisation. (see PaaS Admin interface)  
Send a reminder, including:
    - that the GOV.UK PaaS is a paid service 
    - a link to the [billing calculator](https://admin.cloud.service.gov.uk/calculator).
    - a list of available quotas and suggest one
    - a reminder that approval from the billing manager is required 
4. Ticket is kept in _Pending_ state until the tenant responds. 
5. If the tenant still wants to proceed with the upgrade, continue the upgrade process. Otherwise close the ticket.

### Upgrade approval within GOV.UK PaaS team

GOV.UK PaaS Support can approve the upgrade if: 

 - GOV.UK PaaS has a signed copy of the [Memorandum of Understanding](https://docs.google.com/spreadsheets/d/1HSYj4EEW-Fr6WPaKvYYM_I45Xgay1-707k1Elajgdh8/edit?ts=5b8801d5#gid=939993178) (MOU) for the corresponding department; you can check this on the Engagement team’s [CRM document](https://docs.google.com/spreadsheets/d/1HSYj4EEW-Fr6WPaKvYYM_I45Xgay1-707k1Elajgdh8/edit?ts=5b8801d5#gid=939993178).
 - The org has a confirmed billing manager as the billing contact in the PaaS Admin interface. 

If Support is not confident that these prerequisites are true, Support should request approval from the GOV.UK PaaS Product Manager (PM) via a private response in Zendesk explaining why in the ticket.

### Perform upgrade

Once previous prerequisites are satisfied and/or the PM has approved the upgrade Support will: 

1. Agree the new quota with the tenant.
2. Ask the tenant for billing manager approval, and wait for it.
3. Change the team quota in the GOV.UK PaaS
4. Notify the Product Manager, who finishes the process.

### Notify engagement team

The PM must:

1. Email the Engagement team at common-platforms@digital.cabinet-office.gov.uk about the account upgrade.
2. Send an email from gov-uk-paas-tenant-billing@digital.cabinet-office.gov.uk to the org manager and billing manager, copying in the Engagement team (common-platforms@digital.cabinet-office.gov.uk). See annex.
3. Check with the tenant the expected date their service goes live. 
4. Update the GOV.UK PaaS [list of live services](https://docs.google.com/spreadsheets/d/1iI39lXMaLEVskv5hFI7C0TMAWvGCE_msAITbcEZb1V8/edit#gid=267936930), including the date of upgrade so the GOV.UK PaaS team can start issuing bills at the right time.
5. Close the Zendesk ticket


## Annex

### How to identify trial accounts

To check whether an organisation is in trial, the Product Manager (PM) can either:

- go to the [Billables page](https://admin.cloud.service.gov.uk/reports/cost/2018-07) for the relevant org and check if the quota is default.
- run the following in the command line:

```
cf org org_name
```

### Upgrade notification email

Note: We should move this to http://notifications.service.gov.uk/


Congratulations on upgrading to the GOV.UK PaaS paid service! You can now make full use of the platform. We already have a Memorandum of Understanding with [dept - ]. We will send you a single bill for all of [dept]; the frequency of billing depends on usage across all the orgs in your Department. 

Please tell us when you expect your service to go live so that we can provide you with escalation contact information. Please also send us your emergency contact details.

Please ensure you are familiar with our Terms of Use (TOU) [1]
https://docs.google.com/document/d/1HgEMoLw0JlnvzLTAsj67Ib4Ia2aG3wjf8riCAi1BUJk/edit?usp=sharing

You can see your usage and billing information at any time by logging in to the GOV.UK PaaS Admin tool for London or Ireland. [2]

Feel free to contact me at any time if you need any further information.

[name]
Sr Product Manager
GOV.UK PaaS Team

[1] We need to publish the TOU to the product page. For now, attach the linked page as a PDF
[2] London: https://admin.london.cloud.service.gov.uk/ Ireland: https://admin.cloud.service.gov.uk

[signup]: https://www.cloud.service.gov.uk/signup
[support email]: mailto:gov-uk-paas-support@digital.cabinet-office.gov.uk
[engagement team's CRM]: https://docs.google.com/spreadsheets/d/1HSYj4EEW-Fr6WPaKvYYM_I45Xgay1-707k1Elajgdh8/edit?ts=5b8801d5#gid=939993178
[engagement team email]: mailto:common-platforms@digital.cabinet-office.gov.uk

