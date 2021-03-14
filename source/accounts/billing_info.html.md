# Billing process for GOV.UK PaaS paid accounts

## Introduction

New organisations on GOV.UK PaaS have the option to use a free trial account for a period of 3 months.

After this period we should move that organisation onto a paid account and start billing them. Refer to the team manual for more information on how to move from a trial to paid organisation.

This document outlines how to identify who should be paying, how to kick off billing with a new user and how to track billing.

## Who to bill

There are different quotas for PaaS accounts which allow organisations different levels or memory and space. The available tiers are:

- Default - this is the quota given to trial accounts.
- Small
- Medium
- Large
- 2XLarge
- GDS non chargeable - this is used for internal accounts on a default quota but we didn’t want to display as default so that we wouldn’t keep looking to close or upgrade them

The best way to assess who should be billed is to look at the reporting view on the PaaS admin portal
- [Ireland](https://admin.cloud.service.gov.uk/reports/cost/2019-07-01)
- [London](https://admin.london.cloud.service.gov.uk/reports/cost/2019-07-01)

This view allows you to quickly pick out which orgs are eligible for billing. In general, all tiers other than ‘default’ or ‘GDS non chargeable’ should be billed. There may be some exceptions to this. For example, if a service has agreed with the Product Manager that they need a larger database than ‘default’ for testing, and we have granted that service access to a larger account while they test the platform. Orgs on billable quotas should be tracked in the billable org accounts spreadsheet. Add any useful notes to the comments column.


## Tracking billing

We provide bills with a monthly breakdown. Each month you will need to complete the billing summary for the previous month. Billing summaries are provided per billing manager - some departments have just one person responsible for billing, others may split the billing by org depending on how their internal budget is allocated. You can see the billing manager in the PaaS admin interface by going into the org then selecting ‘members’. Keep the list of billing managers up to date in the Billable Org Accounts spreadsheet.

Find the billing summaries in [Team drive > GOV.UK PaaS > Billing and Pricing PII > Billing record](https://drive.google.com/drive/u/0/folders/1PhFbgFGZWuFkw8D9v-WBYgDdnBEXO9k_)


Complete the record by visiting the organisation billing page on the PaaS admin interface.

To note - we include a 10% admin fee on this page. You can also see monthly bills in the reporting view but the 10% isn’t included in that view so bills would be inaccurate.

Add the monthly total for each department to the Monthly Billing Tracker. This allows us to see a monthly total across all our paying accounts.

## How to bill non GDS orgs

We are trialling a new process for billing, with the PMO team taking more responsibility. This means that we are now only responsible for the initial outreach to departments and collating bills. PMO will be responsible for chasing departments and requesting finance raise invoices.

Before you are able to bill, you will need to have access to send emails from `gov-uk-paas-tenant-billing@digital.cabinet-office.gov.uk`.

We use this address for all billing correspondence so that things won’t get lost in inboxes or held up by annual leave/sickness.

At the start of a financial year or for new organisations who qualify for billing during the financial year and do not fall under an existing purchase order, the following needs to be completed:

- Send an email from the tenant billing address to the organisation billing manager requesting they raise a purchase order (PO) with sufficient funds for the full financial year
  - There is a draft email template for both new and existing orgs found in the GOV.UK PaaS > Billing and Pricing PII folder
- The deadline to raise the PO should be a month from when you send the email
  - Ensure that pmodelivery@digital.cabinet-office.gov.uk are cc’d into the email

- As POs are returned, update the Income Invoice Tracker
  - This document is owned by the PMO team and they request that we use it to track the information they need in order for them to be able to request an invoice be raised

We are not responsible for chasing missing POs. The PMO team are responsible for following up with billing managers who haven’t responded.

Billing frequency is dictated by the level of usage. The table below gives a guideline for billing frequency. When a department is due to be invoiced, you should ensure the invoice tracker is updated and let the PMO team know that an invoice is due to go out.

| Approx. billable amount per month | Billing frequency |
| --- | --- |
|# <£1000 | Yearly |
|#  £1000-£5000 | 6 monthly |
|#  > £5000 | Quarterly |

## Next steps

Our responsibility ends here. However, it is useful to regularly keep in touch with the PMO team to check on billing progress.

We are often asked to report on billing at programme check-ins so it is useful to have up to date knowledge of the billing status of each department.

## Process for cross-charging GDS PaaS tenants

We should cross charge GDS tenants outside of the PaaS team.

The process for charging eligible teams is as follows:
- Track their organisation billing as outlined above
  - Ensure they are noted on the Billable Org Accounts spreadsheet and have billing summaries completed
- Send the billing sheets to pmodelivery@digital.cabinet-office.gov.uk on a quarterly basis
- The PMO team will then arrange cross charging within GDS

You do not need to request a PO or follow up billing in any other way.

## How PaaS sets the exchange rate

GOV.UK PaaS bases its prices on the cost of its infrastructure. Some of this
infrastructure is paid for in dollars. This means there needs to be a record of
the exchange rate between pounds (which tenants are billed in) and dollars
(which some costs are paid in).

GDS pay their AWS bills centrally. Usage is pre-paid in payments of several
million dollars. Therefore the actual exchange rate paid by GDS is the rate at
the point of prepayment, rather than at the point of use.

The PMO team will let PaaS support know whenever a prepayment is made, by
emailing gov-uk-paas-support@digital.cabinet-office.gov.uk with the subject
"Amazon exchange rate". They will tell the team:

* what the exchange rate was (or how many GBP it cost for the payment in USD)
* when the first AWS invoice will be paid from this prepayment

The PaaS team will then update the PaaS billing system with the new exchange
rate valid from the first day of the month where the new prepayment takes
effect.
