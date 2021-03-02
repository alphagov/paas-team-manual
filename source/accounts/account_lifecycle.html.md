# Account lifecycle

## Handling requests for a new trial organisation (org)


Requests to create a new trial org are always handled via Zendesk by the support agent. A range of Zendesk macros are available to speed up the completion of this task.

In most cases, a user will request a trial org by using the form at <https://admin.london.cloud.service.gov.uk/support/sign-up>, which triggers an automated Zendesk ticket. Users should be encouraged to use this route.

### When the request doesn't come through the signup form

In some cases a user might send their request directly to <gov-uk-paas-support@digital.cabinet-office.gov.uk>.

In these cases, use the Zendesk macro `Trial Request > User has bypassed form`, which will request the required information from the user.

If the request comes through any other channel, then it should always be routed into Zendesk by emailing it to <gov-uk-paas-support@digital.cabinet-office.gov.uk>. Use the macro appropriately to collect the required information.

### When requests come from BEIS

Currently we have a special arrangment with the department BEIS. Before granting requests for trial accounts from users at BEIS, use the Zendesk macro `GOVUK PaaS::Account lifecycle::2c. Trial creation BEIS` and wait for a response.

When creating the org, ensure you add the people named in the macro as billing managers.

### When requests come from DfE

Department for Education (DfE) is centrally managing its GOV.UK PaaS usage by having one Org with many Spaces. As such, the DfE digital tools team needs to be notified so they can set up the Spaces and user permissions accordingly. 

There is a macro for this outlining the process `GOVUK PaaS::Account lifecycle::2d. Org creation request DfE` so that we don't proliferate DfE Orgs. 

### Who can request a trial org?

-   Anyone working for a government or public sector organisation 
-   Contractors or third party suppliers working on behalf of the government or public sector
-   Crown or non-crown bodies
-   No Memorandum of Understanding (MOU) is required at this stage

### How to set up a trial org

1. Check you have the information you need to set up the trial org:
  - The name of the service or the team the user is working on
  -   The name of the government organisation or public body that will be using the org
  -   An email address of at least one person who can act as an Org Manager, who can add and remove users to the org.
	   When creating an org, at least one person with an email address belonging to the government organisation or public body using the org must be identified as an Org Manager
  -   The email address of anyone else the user would like to add to the account

    If this information is not provided or is unclear, clarify with the requester.


2. Use `GOV.UK PaaS Admin > Platform Admin > Create new organisation` functionality.

    When identifying the department, use the names listed in the [Government organisations Register](https://www.registers.service.gov.uk/registers/government-organisation) if possible.

3. Confirm the trial org creation with the user

    Use Zendesk macro `Trial request > Trial creation confirm`

## Upgrading trial orgs to paid orgs

Currently there is no form for requesting an upgrade to a paid account. Users need to email <gov-uk-paas-support@digital.cabinet-office.gov.uk>.

It may sometimes be unclear to a tenant that they need to upgrade their org to the paid service, and they might not always explicitly request this. As a support agent, it might sometimes be necessary to infer this need. For example when:

-   the tenant says they need access to a bigger service plan or app memory quota, unavailable on the default quota

-   the tenant asks about "going live" with their service

-   the tenant's other orgs are on paid quotas, they might assume that a new org is automatically going to be created on a paid quota.

### Before you upgrade

Check the [Engagement Tracker](https://trello.com/b/SFyQGwfH/govuk-paas-tracker) to see if that department has signed a Memorandum of Understanding with GDS. Note that Ministry of Defence currently require a separate MOU per service.

If yes, continue to the next step.

If no, escalate to the Delivery Manager, who will need to use the Zendesk macro `Upgrade request > Info capture - No MOU` and support the department to sign an MOU.

### What to do when a user requests an upgrade


1.  Collect the necessary information from the tenant:
    -   the name of the GOV.UK PaaS org that needs upgrading
    -   confirmation that they have approval from the appropriate person or people in your department to start using the paid service
    -   confirmation that they have [added a suitable Billing Manager to their GOV.UK PaaS org account](https://docs.cloud.service.gov.uk/orgs_spaces_users.html#billing-manager). This will be the person or people we will send invoices to and contact about paying for the service.

    If they haven't provided this information up front, use the Zendesk macro `Upgrade request > Info capture - MOU` to ask for it.

    You might need to add some appropriate words before the macro to put it in the context of what the user is trying to do. For example

    > "In order to get access to all the platform's features, you will have to start using the paid service..."
    >
    > "In order to deploy your app to production or start storing user data you will need to start using the paid service..."

1.  Ticket is kept in Pending state until the tenant responds.

2.  If the tenant provides the information satisfactorily, continue the upgrade process.

3.  After upgrading the org, send a confirmation message using the Zendesk macro `Upgrade request > Confirm`

4.  CC the Delivery Manager on the Zendesk ticket, so they can proceed with payment and support onboarding.

### How to upgrade an org
To upgrade an org from a trial to paid, alter the orgs quota using the CF CLI.

```
cf set-quota ORG QUOTA
```

Upgrade a trial org to the `small` quota. The Zendesk macro tells tenants how to request a larger quota.

## Delivery Manager payment and support onboarding 

1.  Send an "Please arrange payment for your GOV.UK PaaS account" email 

    Send the email from gov-uk-paas-tenant-billing@digital.cabinet-office.gov.uk 

    Send the email to 
    -   all Org Managers and Billing Managers for the org
    -   pmo@digital.cabinet-office.gov.uk

    It is important that pmo@digital.cabinet-office.gov.uk is copied into this email because this is used to trigger their bill tracking and payment recovery process.

    [Use the relevant email copy (depending on organisation type)](https://docs.google.com/document/d/1pATbc1uTAJpdkO2B8xg6P9i3NSx5_aBT-G-R6LAeegQ/edit) and link to our [Terms of Use](https://www.cloud.service.gov.uk/terms-of-use)

2. Send "Get support for your service" email 

    Send the email from gov-uk-paas-tenant-billing@digital.cabinet-office.gov.uk 

    Send the email to all Org Managers and Billing Managers for the org

   [Send this information as a PDF or in email copy](https://docs.google.com/document/d/12ak2BP39ElqpSfYp9zudllet-sRe2F9qdZwfv-707jo/edit)

### Delivery Manager updates list of live services and closes ticket

Update the [list of live services](https://drive.google.com/drive/folders/1yYV8X7Rzj4BlAbuFPjsfupouy_1v95eG) - use the most recent version of GOV.UK PaaS usage and adoption tracker in this folder. This is used as a rough count of the number of live services using GOV.UK PaaS - which we sometimes need to report on.

Usually an account upgrade is conducted at an early stage of building the service, and it may take some time until the service might be considered "live".

In these cases the org/service should be marked as "early stage" - until there is a clear indication that the service is going into production soon.

Finally, close the ticket.
