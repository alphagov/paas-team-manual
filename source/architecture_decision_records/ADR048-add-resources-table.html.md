---
title: ADR048 - Include record for services/resources provisioned for tenants
---

# ADR0048: Include record for services/resources provisioned for tenants

## Status

Deprecated

## Context

The GOV.UK PaaS billing system receives a series of events from Cloud Foundry notifying, for each tenant, whether services or resources have been created, renamed, or deleted.

The original GOV.UK PaaS billing system translated the Cloud Foundry events into records of services/resources by calendar month before calculating the final monthly bill for each tenant. This process, called billing consolidation, was done at the start of every month and there was no persistent record of the results of each stage of processing, including what services or resources tenants had provisioned. After each stage of processing database tables were populated but the contents of these tables were impermanent, being refreshed the next time billing consolidation was run.

If there is a problem with a tenant's bill it was very difficult to find the source of the problem.

## Decision

We need to have a persistent record of the services or resources each tenant has provisioned with a dates indicating when the service or resource was/is being used. This persistent record is in the new `resources` table.

The reason for this is that there is no need to regenerate historical records of services or resources provisioned for tenants each time billing is run each month since this information does not change. Furthermore, recording this information for each month makes it difficult for us to calculate bills between any two dates and times.

The `resources` table also acts as an audit point within GOV.UK PaaS billing. It makes investigation of discrepancies in tenant bills easier to investigate. Anyone supporting GOV.UK PaaS billing can first look at the contents of `resources` and see whether the discrepancy arose in the population of `resources` or afterwards in the actual calculation of the bill.

## Consequences

This makes billing easier to support. It also makes billing run much more quickly since we do not need to go through all the Cloud Foundry events whenever we need to calculate tenant bills. With this method we can calculate tenants' bills on-demand, rather than calculating all bills in advance as original GOV.UK PaaS billing system did, so it opens up the possibility of the following:
    - Calculating bills between any 2 dates and times quickly
    - It is easier to break down bills by org, space, etc., or, later on, by annotation

## Deprecation

In the first quarter of 2022 we chose to suspend work on the new billing system, and revert to the old one. The decision 
was prompted by a mix of performance issues in the new code base, and team capacity and prioritisation concerns. 