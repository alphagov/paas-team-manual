---
title: ADR039 - Aiven metrics for users
---

# ADR039: Aiven metrics for users

## Context

We offer our users the following backing services through [Aiven](https://aiven.io):

- Elasticsearch
- InfluxDB (private beta)

We want to make sure our users can view metrics for their Aiven backing services so that our users can:

- debug and respond to usage and service performance changes
- understand the operational characteristics of their applications and services
- make better capacity planning and budgeting decisions

Aiven has service integrations which add extra functionality to an Aiven service. Service integrations are useful for:

- shipping logs to an Elasticsearch/Rsyslog
- sending metrics to Datadog
- sending metrics to Aiven Postgres/InfluxDB
- exposing metrics in Prometheus exposition format

We currently run Prometheus for monitoring the platform, using the [Prometheus BOSH release](https://github.com/bosh-prometheus/prometheus-boshrelease) and have confidence and experience using it.

We will need to think about Prometheus failover. If we load balance Prometheus without sticky sessions, the metrics Prometheus reports will be erratic, as different instances report different metrics.

## Decision

We will use Prometheus to scrape Aiven-provided services.

We will deploy new Prometheus in the Cloud Foundry BOSH deployment using the Prometheus BOSH release. This will reduce blast radius - tenant usage of metrics will not affect our ability to operate and monitor the platform using Prometheus.

We will need to automate the following tasks:

1. Service discovery: make sure Prometheus has an updated list of Aiven services to scrape. We must colocate this automation with the Prometheus instance.
2. Service integration: make sure every eligible Aiven-provided service uses the Aiven service integration for Prometheus.

## Initial implementation

In the initial implementation we deploy multiple instances of Prometheus for high availability.

![architecture](../images/adr450-prometheus-aiven-architecture.svg)

There will be three services on the instance:

- Prometheus
- Caddy
- Aiven service discovery

We use Gorouter for exposing Prometheus publicly.

We use Caddy for failover and for authentication.
Caddy does automatic failover. This means that during regular operation, it proxies all traffic to a single instance, but when the usual instance is unreachable, Caddy will proxy the request to the colocated Prometheus.

The Aiven service discovery process will regularly query the Aiven API to keep
an updated list of Aiven Elasticsearch services for which we want to receive metrics.

The Prometheus server instances will be configured with this list and retrieve
metrics from the respective Aiven Elasticsearch service instances.

This architecture is temporary and we will review it when we look at how to expose the Prometheus API to all users.

## Status

Accepted

## Consequences

We will provide Prometheus as the datastore and interface for (a subset of) tenant metrics.

We will deploy additional stateful instances to our Cloud Foundry BOSH deployment.

We will maintain software to automate the integration of Aiven services and Prometheus.
