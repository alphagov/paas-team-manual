---
title: Dashboard Mac Mini & Chromebox
---

# Dashboard Mac Mini & Chromebox

There are two Mac Minis and a Chromebox attached to big screens in our team area. They can show the
following:

* Outstanding pull requests
* Concourse pipelines
* Pingdom public status page
* Overview of Prometheus triggered monitors

Some combination of the above might be shown according to the whims of the team.
If we want to display multiple different views on a single screen, we use
[frame-splits](https://github.com/dsingleton/frame-splits).

If you need access, you can walk up and use the mouse and keyboard.

The credentials for these machines and for the chromebox are in the `paas-pass` password store.

In case of an AZ failure you can switch to a Grafana instance in a different AZ by replacing the number in the URL. The available URLs are listed [here](/technical_design/prometheus/#urls).

## Outstanding pull requests

These are shown by [Fourth Wall](https://github.com/alphagov/fourth-wall).

To get the URL for our dashboard, you can use these commands:

```
export GITHUB_API_TOKEN=<your github access token>

echo "https://alphagov.github.io/fourth-wall/?token=${GITHUB_API_TOKEN}&team=alphagov/team-government-paas-readonly"
```

Replace the placeholders with read-only [access tokens](https://github.com/blog/1509-personal-api-tokens) from GitHub.

You can store those variables in a [password manager like `paas`](https://www.passwordstore.org/) and load then as needed.

## Concourse pipelines

This shows the pipelines for staging and production on a single screen. The URLs for the pipelines are:

* `https://deployer.london.staging.cloudpipeline.digital/teams/main/pipelines/create-cloudfoundry`
* `https://deployer.cloud.service.gov.uk/teams/main/pipelines/create-cloudfoundry`
* `https://deployer.london.cloud.service.gov.uk/teams/main/pipelines/create-cloudfoundry`

We're using a 
[combined dashboard](https://framesplits.cloudapps.digital/index.html?title=&layout=3row&url%5B%5D=https%3A%2F%2Fdeployer.london.staging.cloudpipeline.digital%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry&url%5B%5D=https%3A%2F%2Fdeployer.cloud.service.gov.uk%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry&url%5B%5D=https%3A%2F%2Fdeployer.london.cloud.service.gov.uk%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry&url%5B%5D=https%3A%2F%2Fdeployer.london.cloud.service.gov.uk%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry).

We're using a [custom Chrome plugin](https://github.com/alphagov/paas-cf/tree/master/misc/chrome_plugins/clean_concourse_pipeline) to hide some of the Concourse page furniture
on the Dashboard. 

## Pingdom

You can use the [Pingdom public status page](http://stats.pingdom.com/ejtodj13fqqx) ([and Pingdom public status page documentation](https://help.pingdom.com/hc/en-us/articles/205386171-Public-Status-Page)) to display the uptime and current status of our healthcheck application. It is not currently presented on the monitors, as we did not find it useful enough. The Pingdom account is shared with other Government-as-a-Platform services, such as Notify, and there is only one shared dashboard for the entire account.

We use the [Super Easy Auto Refresh Chrome extension](https://chrome.google.com/webstore/detail/super-easy-auto-refresh/globgafddkdlnalejlkcpaefakkhkdoa?hl=en) to refresh the page.

## Prometheus Triggered Monitors

We have created a [dashboard in Grafana, called 'User Impact - prod'](https://grafana-1.cloud.service.gov.uk/d/paas-user-impact/user-impact-prod?refresh=5s&orgId=1) and [dashboard in Grafana, called 'User Impact - prod-lon'](https://grafana-1.london.cloud.service.gov.uk/d/paas-user-impact/user-impact-prod-lon?refresh=5s&orgId=1), which displays a count of monitors by trigger status (healthy, warning, critical, or unknown) for each production environment.

The credentials for the Grafana mon users can be found by running `make <env> credhub` from paas-cf.
