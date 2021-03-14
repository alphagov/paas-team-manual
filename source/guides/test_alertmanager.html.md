# Testing Alertmanager

This is a guide to testing Alertmanager

We use Alertmanager for broadcasting and silencing our Prometheus alerts.

## Requirements

 * AWS access
 * CredHub CLI
 * `amtool` - the Alertmanager CLI

Install `amtool` with `go get github.com/prometheus/alertmanager/cmd/amtool`

## Before you start

**1.** [Get credentials](/guides/Connecting_to_Concourse_CredHub_and_BOSH/) to
talk to Alertmanager

**2.** Navigate to Alertmanager's web UI

For example:

| Env | URL |
| --- | --- |
|# Dev | `https://alertmanager-1.tlwr.cloudpipeline.digital` |
|# Staging | `https://alertmanager-1.london.staging.cloudpipeline.digital` |
|# London | `https://alertmanager-1.london.cloud.service.gov.uk` |
|# Ireland | `https://alertmanager-1.cloud.service.gov.uk` |

**3.** Check you can talk to Alertmanager

```
amtool \
  --alertmanager.url=https://admin:<PASSWORD>@alertmanager-1.tlwr.dev.cloudpipeline.digital \
  config show
```

where `<PASSWORD>` is the Alertmanager password from CredHub

_The following `amtool` commands assume that you specify `--alertmanager.url`_

## Checking where alerts go

Alertmanager has a concept of "routes", which dictate where alerts are routed

You can list routes:

```
amtool config routes show
```

which will print:

```
Routing tree:
.
└── default-route  receiver: critical-receiver
    ├── {severity="warning"}  continue: true  receiver: warning-receiver
    ├── {severity="critical"}  continue: true  receiver: critical-receiver
    ├── {notify="pagerduty-24-7"}  continue: true  receiver: pagerduty-24-7-receiver
    └── {notify="pagerduty-in-hours"}  receiver: pagerduty-in-hours-receiver
```

You can see which route would be selected for an imaginary alert:

```
amtool config routes test severity=warning otherlabel=mylabelvalue
```

prints:

```
warning-receiver
```

and

```
amtool config routes test notify=pagerduty-24-7 otherlabel=foo
```

prints

```
pagerduty-24-7-receiver
```

## Simulating an alert

**1.** Notify your colleagues that you are going to be testing alerts

**2.** Add an override in PagerDuty

_You may wish to override both the engineer and the comms schedules, so that
only you are called_

**3.** Create an alert that will expire in 5 minutes

```
amtool alert add \
  this-is-a-test-alert \
  notify=pagerduty-in-hours \
  --end="$(date -v +5M -u '+%Y-%m-%dT%H:%M:%SZ')"
```

**4.** Await your phone call from PagerDuty, and resolve the incident
