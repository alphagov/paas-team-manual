# Dashboard Mac Mini

There's a Mac Mini attached to big screens in our team area. It can show the
following:

* Outstanding pull requests
* Grafana dashboard
* Concourse pipelines
* Pingdom public status page
* Overview of Datadog triggered monitors

Some combination of the above might be shown according to the whims of the team.
If we want to display multiple different views on a single screen, we use
[frame-splits](https://github.com/dsingleton/frame-splits), downloaded locally to the mac-mini to
avoid worrying about sending sensitive urls to the outside world.

If you need access, you can walk up and use the mouse and keyboard, or connect via the OSX Screen Sharing app.

The credentials for this are in the `paas-pass` password store.

To connect, you need to be on the `CDN02_test` wifi network. This network is not configured by default on newly provisioned laptops, so talk to someone else on the team if you need the wifi password. You may need to try to connect several times since the network may not be very reliable.

## Outstanding pull requests

These are shown by [Fourth Wall](https://github.com/alphagov/fourth-wall).

To get the URL for our dashboard, you can use these commands:

```
export GITHUB_API_TOKEN=<your github access token>
export GITHUB_GDS_API_TOKEN=<your github.gds access token>

echo "https://alphagov.github.io/fourth-wall/?token=${GITHUB_API_TOKEN}&team=alphagov/team-government-paas-readonly&github.gds_token=${GITHUB_GDS_API_TOKEN}&github.gds_team=government-paas/read-only"
```

Replace the placeholders with read-only [access tokens](https://github.com/blog/1509-personal-api-tokens) from github and github.gds.

You can store those variables in a [password manager like `paas`](https://www.passwordstore.org/) and load then as needed.

## Grafana Dashboard

AKA User Impact Dashboard.

Found at
```
https://metrics.cloud.service.gov.uk/dashboard/file/user-impact.json
```

Credentials are in the password store.

## Concourse pipelines

This shows the pipelines for CI master, staging and production on a single screen. The URLs for the pipelines are:

* `https://deployer.master.ci.cloudpipeline.digital/`
* `https://deployer.staging.cloudpipeline.digital/`
* `https://deployer.cloud.service.gov.uk/`

The combined dashboard is
[here](http://dsingleton.github.io/frame-splits/index.html?title=&layout=3row&url%5B%5D=https%3A%2F%2Fdeployer.master.ci.cloudpipeline.digital%2F&url%5B%5D=https%3A%2F%2Fdeployer.staging.cloudpipeline.digital%2F&url%5B%5D=https%3A%2F%2Fdeployer.cloud.service.gov.uk%2F).

We're using a custom Chrome plugin to hide some of the Concourse page furniture
on the Dashboard. It can be found
[here](https://github.com/alphagov/paas-cf/tree/master/misc/chrome_plugins/clean_concourse_pipeline).

## Pingdom

We use the [Pingdom public status page](http://stats.pingdom.com/ejtodj13fqqx) ([documented here](https://help.pingdom.com/hc/en-us/articles/205386171-Public-Status-Page)) to display the uptime and current status of our healthcheck application. The Pingdom account is shared with other Government-as-a-Platform services, such as Notify, and there is only one shared dashboard for the entire account.

We use the [Super Auto Refresh](https://chrome.google.com/webstore/detail/super-auto-refresh/kkhjakkgopekjlempoplnjclgedabddk?hl=en) Chrome extension to refresh the page.

## PaaS Overview Dashboard

We use [Smashing](https://github.com/Dashing-io/smashing) to build a dashboard
summarising the state of environments in datadog. The dashboard code is in `paas-cf`.
