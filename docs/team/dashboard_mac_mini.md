# Dashboard Mac Mini

There are two Mac Minis attached to big screens in our team area. They can show the
following:

* Outstanding pull requests
* Grafana dashboard
* Concourse pipelines
* Pingdom public status page
* Overview of Datadog triggered monitors

Some combination of the above might be shown according to the whims of the team.
If we want to display multiple different views on a single screen, we use
[frame-splits](https://github.com/dsingleton/frame-splits).

If you need access, you can walk up and use the mouse and keyboard, or connect via the OSX Screen Sharing app.

The credentials for this are in the `paas-pass` password store.

To connect to the first machine, you need to be on the `CDN02_test` wifi network.
This network is not configured by default on newly provisioned laptops, so talk to someone else on the team if you need the wifi password.
The second machine is on `Bardeen`.
You can find the machines in the Network section of an OSX Finder window, but only if you are on the right network.
If you open a machine, the finder should show you a `Share screen` button.

## Outstanding pull requests

These are shown by [Fourth Wall](https://github.com/alphagov/fourth-wall).

To get the URL for our dashboard, you can use these commands:

```
export GITHUB_API_TOKEN=<your github access token>

echo "https://alphagov.github.io/fourth-wall/?token=${GITHUB_API_TOKEN}&team=alphagov/team-government-paas-readonly"
```

Replace the placeholders with read-only [access tokens](https://github.com/blog/1509-personal-api-tokens) from GitHub.

You can store those variables in a [password manager like `paas`](https://www.passwordstore.org/) and load then as needed.

## Grafana Dashboard

Also known as the User Impact Dashboard.

Found at
```
https://metrics.cloud.service.gov.uk/dashboard/file/user-impact.json
```

Credentials are in the password store.

## Concourse pipelines

This shows the pipelines for staging and production on a single screen. The URLs for the pipelines are:

* `https://deployer.staging.cloudpipeline.digital/teams/main/pipelines/create-cloudfoundry`
* `https://deployer.cloud.service.gov.uk/teams/main/pipelines/create-cloudfoundry`

The combined dashboard is
[here](https://dsingleton.github.io/frame-splits/index.html?title=&layout=2row&url%5B%5D=https%3A%2F%2Fdeployer.staging.cloudpipeline.digital%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry&url%5B%5D=https%3A%2F%2Fdeployer.cloud.service.gov.uk%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry&url%5B%5D=&url%5B%5D=).

We're using a custom Chrome plugin to hide some of the Concourse page furniture
on the Dashboard. It can be found
[here](https://github.com/alphagov/paas-cf/tree/master/misc/chrome_plugins/clean_concourse_pipeline).

## Pingdom

You can use the [Pingdom public status page](http://stats.pingdom.com/ejtodj13fqqx) ([documented here](https://help.pingdom.com/hc/en-us/articles/205386171-Public-Status-Page)) to display the uptime and current status of our healthcheck application. It is not currently presented on the monitors, as we did not find it useful enough. The Pingdom account is shared with other Government-as-a-Platform services, such as Notify, and there is only one shared dashboard for the entire account.

We use the [Super Auto Refresh](https://chrome.google.com/webstore/detail/super-auto-refresh/kkhjakkgopekjlempoplnjclgedabddk?hl=en) Chrome extension to refresh the page.

## PaaS Overview Dashboard

We use [Smashing](https://github.com/Dashing-io/smashing) to build a dashboard
summarising the state of environments in datadog. The dashboard code is in `paas-cf`.

## Automator

Automator applications are used to automatically open a Chrome browser and visit the pages listed above. You can find the applications in `$HOME/Documents/automator`. To edit them you can 'right click' on the Automator icon in the dock and a list of custom applications installed are at the top of the menu.

The actual script is just a simple use of the `open` command. It has not been committed to any repository due to the use of tokens in URLs.

