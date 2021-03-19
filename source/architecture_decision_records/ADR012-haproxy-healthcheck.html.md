---
title: ADR012 - Haproxy healthcheck
---

# ADR012: Haproxy healthcheck

## Context

Stories: [#123490171](https://www.pivotaltracker.com/story/show/123490171) & [#121933113](https://www.pivotaltracker.com/story/show/121933113)

We were investigating how to avoid downtime to deployed applications when we
made changes to the platform. We had discovered that short outages occurred
when the gorouter was taken out of service.

gorouter has drain functionality to allow upstream load balancers to gracefully
take instances of the gorouter out of service before any requests start to
fail.

When a USR1 signal is sent to instruct the gorouter to start draining,
healthchecking requests, identified by the header `User-Agent: HTTP-Monitor/1.1`
start failing with HTTP 503. User requests are allowed to continue.

Two things prevented us from using drain mode:

- we had the ELB configured to use TCP healthchecks, not HTTP
- the ELB sends HTTP healthcheck requests with `User-Agent:
  ELB-HealthChecker/1.0`, which means they were not recognised as healthcheck
  requests by gorouter, they returned HTTP 200 and the ELB did not take the
  draining gorouter out of service.

The result was a very small amount of downtime for deployed apps that received
requests during a short window of < 1 second.

## Decision

We decided to:

- submit a change upstream to [allow the gorouter to recognise ELB
  healthchecks](https://github.com/cloudfoundry/gorouter/pull/138)
- implement a healhchecking port 82, in the HAProxy we introduced in ADR008,
  which appends the `User-Agent: HTTP-Monitor/1.1` that gorouter expects
- enable HTTP healthchecks on the ELB


## Status

Accepted

## Consequences

- There was less downtime for deployed applications during a deploy.
- We have an additional reason to keep the intermediate HAProxy we introduced as a temporary measure.
