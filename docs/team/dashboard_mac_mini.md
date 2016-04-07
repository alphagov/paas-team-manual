# Dashboard Mac Mini

There's a Mac Mini attached to big screens in our team area. It shows the
following:

* Jenkins build status
* Outstanding pull requests
* Grafana dashboard
* Concourse pipelines


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
