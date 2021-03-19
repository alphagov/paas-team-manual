---
title: ADR021 - Cell capacity assignment 2
---

# ADR021: Cell capacity assignment 2

## Context

We've been running with the cell provisioning policy in ADR017 since February.
We haven't ever run out of cell capacity, but we've observed that there's
excess capacity that we're paying for.

At the time that we wrote ADR017 we had fewer tenants and an individual
tenant's quota was a much greater proportion of total memory size. In other
words a single tenant could conceivably use a greater proportion of our excess
capacity.

Cells are still deployed across 3 AZs.

We still don't have a way to autoscale the number of cells to meet demand, so
we need to ensure that we have surplus capacity for when we're not around.

Cells are almost completely uncontended; we're not experiencing CPU or disk I/O
contention and not all the cell memory is being used.

Over the 3 month period from 1st August - 1st November

- Usable memory (free + cached + buffered) is running between 77% and 92% of total cell memory
- The maximum increase in memory usage over an exponentially smoothed average from a week previously was 36%
- We're running at about 10% of our total container capacity
- container usage has peaked at about 20% above the previous weeks
- Average CPU usage is about 10%. We see daily peaks of 80%
- reps think that about 50% of the capacity of cells is used
- the largest amount that rep's allocated memory increased week on week was 55%


## Decision

Our objectives are:

State | Expected behaviour
------|-------------------
# All cells operational | Enough capacity to allow some but not all tenants to scale up to their full quota. The amount of excess capacity required should be enough to accommodate the fluctuations we can expect over a 3 day period (weekend + reaction time)
# While CF being deployed | As above: enough capacity to allow some tenants to scale up to their full quota
# One availability zone failed/degraded | Enough capacity to maintain steady state app usage. Not guaranteed to be able to scale apps up.
# More than one AZ failed | The system is not expected to have sufficient capacity to host all running apps.

To achieve this we need to start basing our capacity planning on current memory
occupied by processes on cells, rather than the sum of all quotas given to
users. We will define alerts for capacity planning purposes, the in-hours
support person is expected to respond by adjusting the number of cells.

We want to ensure that cells have some headroom above a smoothed
average:

- to allow some headroom for increases in the memory consumed by apps.
- to allow buffering and caching to occur and not adversely impact application
  performance.

From our data analysis (see context) the amount of memory consumed by apps
can reach about 36% over a week-ago's smoothed average. We round up to 40% to
include buffering/caching.

If an AZ fails, we need enough capacity remaining to host all our apps. The
failed AZ's apps are evenly divided amongst the surviving AZs. Because we have
two remaining AZs, each surviving AZ will have 1.5x as many apps running.

Because we want 40% headroom, we'll want 1.4 (headroom) x 1.5 (evacuated apps)
current usage. This is about 2x actual memory consumed by processes on cells.

Therefore we need to start alerting when the memory occupied by processes on
cells is above 50%, when suitably smoothed to avoid noise / small spikes
causing frequent alarms.

CPU usage is assumed to be a linear relation of memory usage and we will have a
similar alert defined when it exceeds 50% on cells.

In addition to wanting the cells to not run short on memory, we also want
tenants to be able to scale apps up and down when all AZs are functional. In
order to ensure this, we need to allow for a ~50% increase in requested memory,
which means alerting when all the reps have a cumulative remaining capacity of
~33%, when smoothed to avoid false alarms.

We also need enough container capacity to allow tenants to scale apps up and
down and deploy new apps. We should alert when we're using > 80% of the sum of
our reps' container capacity. Again, this should be smoothed to ensure that
short lived fluctuations in usage don't cause unnecessary alerts.

It is likely that patterns such as the fluctuation in memory use over a week
may change over time. We should review this decision after 6 months.

## Status

Proposed

## Consequences

We will alert on the following metrics:

- exponentially weighted moving average of used memory (not including cache) averaged over cells > 50%
- smoothed idle CPU averaged across cells < 50% (Note: This metric superceeded by [ADR23](/architecture_decision_records/ADR023-idle-cpu-alerting-change/))
- smoothed container count (as reported by rep) of > 80% of capacity
- smoothed available memory capacity (as reported by rep) of < 33%

We will remove half the cells, but not all in one go. We should start by removing 1/4 of cells.

After removing 1/4 of the cells, we should consider:
- adjusting [rep's advertised memory
  capacity](https://github.com/cloudfoundry/diego-release/blob/5f822ca91f9289de240924b90b6feabb06248ed8/jobs/rep/spec#L147)
in order to allow overcommitment.
- whether we should remove another 1/4 of the original capacity (1/3 of current capacity)

We will save money.
