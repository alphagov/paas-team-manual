---
title: ADR023 - Idle CPU alerting change
---

# ADR023: Idle CPU alerting change

## Context

With the implementation of ADR021 we have reduced the number of cells in
production in order to make more efficent use of our budget. This in turn means
that we have increased the load on the individual cells. Originally the idle CPU
monitor was set in line with the free memory on cells monitor (for alerting on
a need to scale the cell pool), however CPU usage does not appear to grow
linearly with allocated memory for tenant applications.

## Decision

In order to avoid false positives from triggering due to CPU load spiking rather
than being a constant level we will increase the monitoring window to 24 hours.
Based upon examining our CPU idle load in ADR021, we will reduce the CPU idle
thresholds to warn at 37% and become critical at 33%.

## Status

Accepted

## Consequences

We will alert on the following metrics:

- idle CPU averaged across 1 day of cells < 33%

We will warn on the following datadog metrics:

- idle CPU averaged across 1 day of cells < 37%

We will not be annoyed by false positive alerts.
