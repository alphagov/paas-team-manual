---
title: ADR028 - Migrate CF platform logs to Logit
---

# ADR028: Migrate CF platform logs to Logit

## Context
The work to ship cloud foundry platform logs to Logit was started in 2018 Q1.
It was paused because some IA issues with Logit were not resolved. At one point
RE recommended that PaaS should host our own logstash as this part of the
service was not widely available by market Elastic SaaS providers. The PaaS
team was also considering to use Elasticsearch on AWS with our accounts.

## Decision
An updated conversation with the RE tool team has confirmed that the IA issues
had been resolved, and that GDS can continue to use Logit for now.

It is a GDS strategy to use a consistent logging solution. Hence, we should
continue our migration of platform logs to logit, including our logstash
filters.

There is considerably less maintenance work for us if we use Logit's logstash
filter rather than hosting the bosh release one. In the future if GDS choose to
use another vendor that do not have a hosted logstash solution, they would need
to provide a migration strategy for all the current logstash users.

## Status
Approved

## Consequences
We will continue the migration of platform logs to logit including logstash,
and take a risk that we may need to spin up our logstash in the future if GDS
choose a different platform logs provider.
