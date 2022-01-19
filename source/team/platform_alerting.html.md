---
title: Responding to Platform Alerting
---

# Responding to Platform Alerting

Prometheus is configured to send alerts to teams mailing lists.

You can check and subscribe to these alerts in each corresponding mailing list page (Google Groups):

- [Group for govpaas-alerting-dev@digital.cabinet-office.gov.uk](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govpaas-alerting-dev)
- [Group for govpaas-alerting-ci@digital.cabinet-office.gov.uk](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govpaas-alerting-ci)
- [Group for govpaas-alerting-staging@digital.cabinet-office.gov.uk](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govpaas-alerting-staging)
- [Group for govpaas-alerting-prod@digital.cabinet-office.gov.uk](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/#!forum/govpaas-alerting-prod)

## BOSHJobEphemeralDiskPredictWillFill Diego Cell Alert

This alert may not require any action as it evaluates changes over a 30 minute period and then extrapolates it over 4 hours.

Action is required if we receive a `BOSHJobEphemeralDiskFull` alert. You can resolve this alert by recreating the instance.

For diego cells, GrootFS is allowed to fill 88% of the disk while the rest is reserved for other jobs. Garbage collection occurs when a container is created so disk full alerts are likely to be triggered by other jobs on the cell.
