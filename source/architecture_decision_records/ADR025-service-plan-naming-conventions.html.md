---
title: ADR025 - Service plan naming conventions
---

# ADR025: Service plan naming conventions

## Context

Our service plans have evolved incrementally over the last few years and are in
need of some attention. Names are inconsistent, potentially confusing and
in many cases contain irrelevant redundant information that is of no practical
use to the platform operators or to tenants consuming the service.

Adding additional versions of services has the potential to compound the
problem by multiplying plans of different characteristics with different
versions.

## Decision

We have decided to use the following naming convention for naming plans going forward:

```
SIZE[-HA][-LABEL,-LABEL,...]-VERSION
```

Where:

* `SIZE` is a string describing the scale one of the plan, it should be one of: `xlarge` `large` `medium` `small` `tiny`.
* `HA` is the string `ha` to indicate highly available if relevent.
* `LABEL` is a string describing some specific variant of the service if relvent.
* `VERSION` is the version number of the service plan.

### For example:

A large multi-az postgres plan for version 9.6 would be `large-ha-9.6`.

A small not multi-az, unclustered, redis 3.2 plan would be `redis-unclustered-3.2`.

### Example migrations of some existing plans:

```
L-HA-enc-dedicated-9.5 => large-ha-9.5
M-HA-enc-dedicated-9.5 => medium-ha-9.5
tiny-clustered => tiny-clustered-3.2
tiny-unclustered => tiny-unclustered-3.2
```

### Additionally:

* We will avoid use of the word "free" in names.
* We will avoid using redundent words (like 'dedicated') in names to reduce noise.
* We will avoid use of uppercase characters in names.
* We will avoid abbriviations where possible ("medium" instead of "M", "large" instead of "L").
* We will avoid offering unencrypted plans where an encrypted version is available (legacy unencrypted plans will be explicitly labelled with `-unencrypted` and hidden from the marketplace).


## Status

Accepted

## Consequences

Renaming exisiting plans to conform to this format may be disruptive to tenants who may rely on the old names in scripted deployements.
