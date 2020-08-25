# ADR039: Aiven metrics for users

## Context

We offer backing services via [Aiven](https://aiven.io) to our users:

- Elasticsearch
- InfluxDB (private beta)

We want to ensure our users can view metrics for their Aiven backing services so that our users can:

- debug and respond to usage and service performance changes
- understand the operational characteristics of their applications and services
- make better capacity planning and budgeting decisions

Aiven has service integrations which add extra functionality to an Aiven service. Service integrations can be used to:

- ship logs to an Elasticsearch/Rsyslog
- send metrics to Datadog
- send metrics to Aiven Postgres/InfluxDB
- expose metrics in Prometheus exposition format

We currently run Prometheus for monitoring the platform, using the [Prometheus BOSH release](https://github.com/bosh-prometheus/prometheus-boshrelease) and have confidence and experience using it.

We will need to think about Prometheus failover. If we load balance Prometheus without sticky sessions, then the metrics reported by Prometheus will be erratic as different instances report different metrics.

## Decision

We will use Prometheus to scrape Aiven provided services.

We will deploy new Prometheis in the CF BOSH deployment using the Prometheus BOSH release. This will reduce blast radius - tenant usage of metrics will not affect our ability to operate and monitor the platform using Prometheus.

We will need to automate the following tasks:

- Service discovery: ensure Prometheus has an updated list of Aiven services to scrape. This automation must be colocated with the Prometheus instance.
- Service integration: ensure every eligible Aiven provided service uses the Aiven service integration for Prometheus.

## Initial implementation

In the initial implementation we deploy multiple instances of Prometheus for high availability.

![architecture](../images/adr450-prometheus-aiven-architecture.svg)

There will be three services on the instance:

- Prometheus
- Caddy
- Aiven service discovery

We use gorouter for exposing Prometheus publicly.

We use Caddy for failover and for authentication.
Caddy does automatic failover, such that during regular operation all traffic gets proxied to a single instance, but when the usual instance is unreachable, Caddy will proxy the request to the colocated Prometheus.

This architecture is temporary and will be revisited when we look at how to expose the Prometheus API to all users.

## Status

Accepted

## Consequences

We will provide Prometheus as the datastore and interface for (a subset of) tenant metrics.

We will deploy additional stateful instances to our CF BOSH deployment.

We will maintain software to automate the integration of Aiven services and Prometheus.
