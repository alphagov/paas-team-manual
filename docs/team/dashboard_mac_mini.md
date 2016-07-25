# Dashboard Mac Mini

There's a Mac Mini attached to big screens in our team area. It shows the
following:

* Outstanding pull requests
* Grafana dashboard
* Concourse pipelines
* Pingdom public status page


## Concourse pipelines

This shows the pipelines for CI master, staging and production on a single screen. The URLs for the pipelines are:

* `https://deployer.master.ci.cloudpipeline.digital/`
* `https://deployer.staging.cloudpipeline.digital/`
* `https://deployer.cloud.service.gov.uk/`

The combined dashboard is
[here](http://dsingleton.github.io/frame-splits/index.html?title=&layout=3row&url%5B%5D=https%3A%2F%2Fdeployer.master.ci.cloudpipeline.digital%2F&url%5B%5D=https%3A%2F%2Fdeployer.staging.cloudpipeline.digital%2F&url%5B%5D=https%3A%2F%2Fdeployer.cloud.service.gov.uk%2F).

We're using a custom Chrome plugin to hide some of the Concourse page furniture
on the Dashboard. It can be found
[here](https://github.com/alphagov/paas-cf/tree/master/concourse/chrome_plugin).

## Pingdom

We use the [Pingdom public status page](http://stats.pingdom.com/ejtodj13fqqx) ([documented here](https://help.pingdom.com/hc/en-us/articles/205386171-Public-Status-Page)) to display the uptime and current status of our healthcheck application. The Pingdom account is shared with other Government-as-a-Platform services, such as Notify, and there is only one shared dashboard for the entire account.

We use the [Super Auto Refresh](https://chrome.google.com/webstore/detail/super-auto-refresh/kkhjakkgopekjlempoplnjclgedabddk?hl=en) Chrome extension to refresh the page.