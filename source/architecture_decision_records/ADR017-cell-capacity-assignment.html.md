---
title: ADR017 - cell capacity assignment
---

# ADR017: cell capacity assignment

## Superceded

This has been superceded by [ADR021](/architecture_decision_records/ADR021-cell-capacity-assignment-2/) since November 2017. It has been retained for historical purposes.

------------------------


## Context

We want to ensure our platform remains available when a single AZ fails. This means that we need to have enough spare memory capacity left on cells to cover deploying apps from the failed zone. In case of 3 zones, that means each zone should be able to host 50% more apps (memory capacity wise). We can calculate maximum memory usable by all orgs by doing sum of their quotas. However, in practice much less memory is consumed. This is because

1. Org quotas come in T-shirt sizes and have considerable size jumps (e.g. 2, 10, 60 100G). You need to reserve next quota if previous one is too small for your needs, yet it doesn't mean you will be using all the capacity of the larger quota.
1. App instance memory limits are set as upper memory consumption limit. Because of that, they tend to be set larger for safety. Actual app memory consumption is always lower, many times considerably.

Practical example - this is a snapsot of our prod deployment in Feb 2017:

```
Memory reserved by orgs: 368640 MB (360 GB)
Memory reserved by apps: 107108 MB (104 GB)
Memory actually used by apps: 32868 (32 GB)
```

This is not unusual and CF v1 had default overprovisioning factor of 2 (that is, it advertised 2 times more capacity than actual).

## Decision

We will maintain at least 50% of total org reserved capacity available when a zone fails. That is, remaining zones will have to be able to cover 50% of total reserved capacity.

## Status

Superceded by [ADR021](/architecture_decision_records/ADR021-cell-capacity-assignment-2/).

## Consequences

* We will check if we have enough capacity available whenever we add a new organisation or increase quota of existing one. We will deploy more cells if we need more capacity.
* We have implemented `show-cf-memory-usage` makefile target to help us get current org and app reservation and real usage totals.
