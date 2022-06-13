---
title: ADR049 - Decouple what we're calculating bills for from how the bills are calculated
---

# ADR0049: Decouple what we're calculating bills for from how the bills are calculated

## Status

Deprecated.

## Context

Tenants provision a wide variety of services and AWS/Aiven resources via GOV.UK PaaS. We need to calculate bills for these services/resources. GOV.UK PaaS billing receives notifications of when services or resources are created, renamed, or deleted from upstream in the form of events from Cloud Foundry.

The original GOV.UK PaaS billing system translated the Cloud Foundry events into records of services/resources by calendar month before calculating the final monthly bill for each tenant. This process, called billing consolidation, was done at the start of every month and there was no persistent record of the results of each stage of processing, including what services or resources tenants had provisioned. After each stage of processing database tables were populated but the contents of these tables were impermanent, being refreshed the next time billing consolidation was run.

In the GOV.UK PaaS billing rewrite, this has been changed. We want to calculate bills for variable time periods and also to forecast bills for the future (for the web-based billing calculator). However, the method to calculate the actual bill always needs to be the same.

## Decision

The code to calculate the bill has been decoupled from the code used to calculate the bill. This is so we can use exactly the same code for calculation of all bills, whether these bills are for tenants or for prospective tenants (using the billing calculator).

The approach taken is:
    1. Populate database temporary table with what is being billed (which resources over which time interval, including the future). This can be in a stored function or embedded SQL. This is the code entry point into billing.
    2. Call a stored function to calculate the bill ([`calculate_bill`](https://github.com/alphagov/paas-billing/blob/main/billing-db/sprocs/calculate_bill.sql)) only using the contents of the temporary table populated in step 1 above. No parameters are passed into ([`calculate_bill`](https://github.com/alphagov/paas-billing/blob/main/billing-db/sprocs/calculate_bill.sql)).

## Consequences

Importantly, this means that we can have a single source of truth for calculating all GOV.UK PaaS bills. Tenants' bills or prospective tenants' bills, the latter using the billing calculator, will be calculated using the same code.

All we need for this is to have different code entry points into billing. We can either do step 1 above using another stored function, or using embedded SQL for a more tailored approach. For example, for step 1 above we could have the following code entry points:

- Display tenant bills for the past and/or future, aggregated by org_name, org_guid, plan_guid, plan_name, space_name, resource_type, resource_name, component_name. This has been done in [`get_tenant_bill`](https://github.com/alphagov/paas-billing/blob/main/billing-db/sprocs/get_tenant_bill.sql).
- Calculate bills for prospective tenants. This code has not yet been written but can be used to simplify the billing calculator (on GOV.UK PaaS website) to ensure it calculates bills using exactly the same code as is used to calculate historic bills. All that needs to be done is to populate the temporary table with what the tenant would like to calculate the cost of.
- Display bills for RDS for all tenants, for example.

We can also easily tailor the billing reports in step 1 by different output fields, and enable reports to be filtered by input field (e.g. get bills just for RDS Postgres for a tenant, for example).

## Deprecation

In the first quarter of 2022 we chose to suspend work on the new billing system, and revert to the old one. The decision
was prompted by a mix of performance issues in the new code base, and team capacity and prioritisation concerns. 