---
title: Prometheus
---

# Prometheus

## High availability

All components run at least on two different VMs in different availability zones.

All Prometheus instances are independent and scrape the metrics endpoints separately. This means the Prometheus instances will have slightly different data (because of different scraping times). For various reasons (downtime, restart, etc.) one Prometheus instance might also have some data missing compared to the others.

All Prometheus instances will send alerts to all alertmanagers. The alertmanagers form a separate cluster and will deduplicate any identical alerts.

The Grafana instances will connect only to the Prometheus instance which is in the same availability zone.

All instances have a unique url, so in case of an AZ failure you can use the monitoring urls from the working AZ.

### Logging in to `grafana-2`

Due to a quirk in how the Grafanas are provisioned, they both share the same Google auth client id, and so attempting to log in to `grafana-2` will cause the auth flow to be redirected back to `grafana-1` which will show an error. Simply changing URL in the address bar at this point back to the `grafana-2` equivalent address should allow authentication to succeed.

## Alerting

Prometheus is configured to send alerts to teams mailing lists.

You can find these mailing lists [here](/team/platform_alerting/).

## URLs

### Primary

| Ireland                                                                            | UK                                                                                               |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
|# [prometheus-1.cloud.service.gov.uk](https://prometheus-1.cloud.service.gov.uk)     | [prometheus-1.london.cloud.service.gov.uk](https://prometheus-1.london.cloud.service.gov.uk)     |
|# [alertmanager-1.cloud.service.gov.uk](https://alertmanager-1.cloud.service.gov.uk) | [alertmanager-1.london.cloud.service.gov.uk](https://alertmanager-1.london.cloud.service.gov.uk) |
|# [grafana-1.cloud.service.gov.uk](https://grafana-1.cloud.service.gov.uk)           | [grafana-1.london.cloud.service.gov.uk](https://grafana-1.london.cloud.service.gov.uk)           |

### Secondary

| Ireland                                                                            | UK                                                                                               |
| ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
|# [prometheus-2.cloud.service.gov.uk](https://prometheus-2.cloud.service.gov.uk)     | [prometheus-2.london.cloud.service.gov.uk](https://prometheus-2.london.cloud.service.gov.uk)     |
|# [alertmanager-2.cloud.service.gov.uk](https://alertmanager-2.cloud.service.gov.uk) | [alertmanager-2.london.cloud.service.gov.uk](https://alertmanager-2.london.cloud.service.gov.uk) |
|# [grafana-2.cloud.service.gov.uk](https://grafana-2.cloud.service.gov.uk)           | [grafana-2.london.cloud.service.gov.uk](https://grafana-2.london.cloud.service.gov.uk)           |
