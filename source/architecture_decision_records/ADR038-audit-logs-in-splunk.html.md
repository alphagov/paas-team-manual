---
title: ADR038 - Audit logs in Splunk
---

# ADR038: Audit logs in Splunk

## Context

### Audit events

The GOV.UK PaaS has components which expose events which can be used for
auditing. For example:

- BOSH director kernel audit logs
- BOSH director Credhub security events
- BOSH director UAA events
- Cloud Foundry UAA events
- Cloud Foundry Cloud Controller security events

The BOSH director and BOSH managed instances store these logs in
`/var/vcap/sys/log/`.

### Logging service

The Cyber Security team run a centralised log ingestion system called the
Central Security Logging Service (CSLS).

This service runs in AWS and uses [CloudWatch log group subscription
filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html)
to ingest logs, which are then sent to Splunk for indexing.

## Decision

We will use Terraform to create log groups in our existing pipelines:

- `create-bosh-concourse`
- `create-cloudfoundry`

We will store audit logs in CloudWatch for 18 months (545 days).

We will use Terraform to create log group subscription filters which will send
logs to CSLS.

Terraform failing to create log group subscription filters should not block the
execution of the pipeline, so our pipelines are not coupled to CSLS.

We will run a fork of the
[awslogs-boshrelease](https://github.com/alphagov/paas-awslogs-boshrelease),
on all instances that have relevant audit and security event logs, to send logs
from the instances to CloudWatch.

The CloudWatch log groups will have subscription filters that will send logs
to CSLS so that logs are indexed in Splunk.

## Status
Accepted

## Consequences

We will store audit and security events for 18 months.

We will share audit and security events with Cyber Security using CSLS.
