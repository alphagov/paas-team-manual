# Audit

To hold operators and users to account, and to meet compliance requirements, we
store and audit operator and platform events.

## BOSH

In each environment we have a VM which runs BOSH and has components:

- BOSH Director
- UAA
- CredHub

These components log security events to disk.

Additionally, SSH daemons and other kernel audit logs generate useful logs.

Additionally, the BOSH director has an API which lists events, for example:

- SSH session creation
- SSH cleanup
- Variable creation
- Deployment create/update/delete

To better audit operator actions, we ship audit events to [Splunk](https://gds.splunkcloud.com/).

We ship events to Splunk via two mechanisms:

1. [bosh-auditor](https://github.com/alphagov/paas-observability-release/tree/master/src/bosh-auditor)
  - fetches events from Director's events API
  - ships them to the Splunk Cloud HTTP Event Collector (HEC)
  - An operator can retrieve BOSH audit events with
      - `index=paas sourcetype="bosh-audit-event"`

2. An awslogs agent on each instance
  - ships events on disk to CloudWatch
  - CloudWatch forwards logs to Cyber's Central Security Logging Service ([CSLS](https://github.com/alphagov/centralised-security-logging-service))
  - CloudWatch stores shipped events for 18 months

### Diagram

- `bosh-auditor` is a BOSH job colocated with the director
- dashed arrows mean read
- solid arrows mean write or use

![Diagram of BOSH events](/diagrams/audit-bosh.svg)

## Cloud Foundry

In each environment we have components which generate events which we should audit:

- Cloud Controller API
- UAA

Additionally, SSH daemon's and other kernel audit logs generate useful logs.

To better audit operator actions, and the actions of PaaS users, we ship audit events to Splunk.
We ship events to Splunk via two mechanisms:

1. [paas-auditor](https://github.com/alphagov/paas-auditor)
  - fetches events from Cloud Controller's events API
  - stores events in a database
  - ships them to the Splunk Cloud HTTP Event Collector (HEC)
  - An operator can retrieve CF audit events with
      - `index=paas sourcetype="cf-audit-event"`

2. An awslogs agent on each instance
  - ships events on disk to CloudWatch
  - CloudWatch forwards logs to Cyber's Central Security Logging Service ([CSLS](https://github.com/alphagov/centralised-security-logging-service))
  - CloudWatch stores shipped events for 18 months

### Diagram

- `paas-auditor` is a Cloud Foundry app
- dashed arrows mean read
- solid arrows mean write or use

![Diagram of Cloud Foundry events](/diagrams/audit-cloudfoundry.svg)
