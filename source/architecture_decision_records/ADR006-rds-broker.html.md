---
title: ADR006 - RDS broker
---

# ADR006: RDS broker

## Context

We need to provide tenants with the ability to provision databases for use in
their applications. Our first iteration of this will be using RDS.
We investigated some implementations of a service broker which supported RDS

 - [cf platform eng](https://github.com/cf-platform-eng/rds-broker)
 - [18F](https://github.com/18F/rds-service-broker)

## Decision

We will use the [cf platform eng](https://github.com/cf-platform-eng/rds-broker)
rds broker. As this is not a supported product, we will fork this and maintain
this and implement new features ourselves.

## Status

Accepted

## Consequences

We will be maintaining a new service broker, but have a head start on creating
it by basing it on an existing service broker.
