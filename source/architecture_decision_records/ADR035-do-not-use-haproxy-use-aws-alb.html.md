---
title: ADR035 - Do not use HAProxy ; Use AWS ALBs
---

# ADR035: Do not use HAProxy ; Use AWS ALBs

## Context

In ADR008 and ADR014 we decided to use HAProxy, for three reasons:

- Writing HSTS header if they are not present in the upstream request
- Implementing HTTP -> HTTPS redirect
- Custom health check for Gorouter

These problems have since been fixed:

- Header rewriting was implemented in [v0.183.0](https://github.com/cloudfoundry/routing-release/releases/tag/0.183.0)
- HTTP healthchecking was implemented in [v0.139.0](https://github.com/cloudfoundry/routing-release/releases/tag/0.139.0)
- HTTP -> HTTPS redirect can be done using AWS ALBs

We currently use multiple ELBs (classic) which we want to replace with ALBs.
We want to use ALBs because:

- ELBs are deprecated in terraform and cause crashes
- ALBs can give us more metrics in CloudWatch
- ALBs have better support for X-Forwarded-For
- ALBs support fixed-response which can be used for HTTP -> HTTPS rewriting

HAProxy adds significant complexity to our routing deployment and maintenance:

- Proxy Protocol is non-standard and hard to understand
- HTTP -> HTTPS rewriting is hard to understand
- HAProxy config is rarely touched
- We have to maintain our own HAProxy BOSH release
- HAProxy duplicates the number of logs we receive because every platform request is written twice
- HAProxy adds an extra network hop for every request

## Decision

- Replace ELBs with ALBs
- Use ALB fixed-response to redirect HTTP -> HTTPS
- Use Gorouter directly for:
  - TLS termination
  - HSTS header rewriting
  - Healthchecking the router instance
- Remove HAProxy

## Status

Accepted

## Consequences

- We will archive alphagov/paas-haproxy-release
- We must use Gorouter's /health endpoint for drained healthchecking
- We must communicate with tenants that the X-Forwarded-For header contents will change
- We will no longer have HAProxy logs, and save money on log ingestion/storage
