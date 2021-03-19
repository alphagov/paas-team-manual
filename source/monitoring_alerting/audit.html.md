---
title: Auditing operator and platform events
---

# Auditing operator and platform events

To hold operators and users to account, and to meet compliance requirements, we
store and audit operator and platform events.

## BOSH

In each environment, we have a virtual machine (VM) which runs [BOSH](https://bosh.io/docs/) and has the following components:

- BOSH Director
- UAA
- CredHub

These components log security events to disk.

Additionally, SSH daemons and other kernel audit logs generate useful logs and the BOSH director has an API which lists events, for example:

- SSH session creation
- SSH cleanup
- Variable creation
- Deployment create/update/delete

To better audit operator actions, we ship audit events to [Splunk](https://gds.splunkcloud.com/).

We ship events to Splunk in two ways:

1. [bosh-auditor](https://github.com/alphagov/paas-observability-release/tree/master/src/bosh-auditor) is a BOSH job colocated with the BOSH Director. It:
    - fetches events from the Director's events API
    - ships them to the Splunk Cloud HTTP Event Collector (HEC)

    An operator can retrieve BOSH audit events with:

    `index=paas sourcetype="bosh-audit-event"`

2. An AWS CloudWatch logs agent on each instance ships events on disk to CloudWatch. CloudWatch then forwards logs to Cyber's Central Security Logging Service ([CSLS](https://github.com/alphagov/centralised-security-logging-service)) and stores shipped events for 18 months.

![Diagram of BOSH events](/diagrams/audit-bosh.svg)

## Cloud Foundry

In each environment, the following components generate events we should audit:

- Cloud Controller API
- UAA

Additionally, SSH daemons and other kernel audit logs generate useful logs.

To better audit operator actions, and the actions of PaaS users, we ship audit events to Splunk in two ways:

1. [paas-auditor](https://github.com/alphagov/paas-auditor) is a Cloud Foundry app which fetches events from Cloud Controller's events API, stores the events in a database and ships them to the Splunk Cloud HTTP Event Collector (HEC).

    An operator can retrieve CF audit events with:

    `index=paas sourcetype="cf-audit-event"`

2. An AWS CloudWatch logs agent on each instance ships events on disk to CloudWatch. CloudWatch then forwards logs to Cyber's Central Security Logging Service ([CSLS](https://github.com/alphagov/centralised-security-logging-service)) and stores shipped events for 18 months.

![Diagram of Cloud Foundry events](/diagrams/audit-cloudfoundry.svg)
