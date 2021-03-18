---
title: ADR020 - Deletion of ci environment
---

# ADR020: Deletion of ci environment

## Context

We have three environments in our deployment pipeline. Two non-production ones - CI and Staging and one Production. We think that it takes to much time for a change to reach production state in the current setup. We don't think having two environments before production is providing us much value, compared to the cost of running, maintaining, and waiting for deployments to be promoted.

## Decision

We will delete CI environment and migrate it's customizations, like tests , apps etc. to staging. We have decided to delete CI instead of staging as we want to separate build CI in it's own AWS account. Also, staging environment has valid certificates.

## Status

Accepted.

## Consequences

We will have less environments to maintain and a change will be able to reach production state quicker.
