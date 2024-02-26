# Scaling Routers Horizontally

PaaS is being retired and tenants are migrating their workloads to other platforms. As a result the AWS IaaS has more resources than is required to reliably and effectively support the workload.

This section of the manual will discuss how to horizontally scale the Cloud Foundry routers such that they are being used effectively and efficiently.

There is a [blog from Cloud Foundry](https://www.cloudfoundry.org/blog/routing-performance/) which publishes a benchmark test which offers guidance on horizontally scaling routers. The outcome of the test is that the cpu usage of each router should be kept to below 70% otherwise latency will increase.

There are two useful dashboards readily available to assist in estimating the number of router instances that are required in an environment. Using prod-lon as the example source environment, they are [Andy's noodle dashboard](https://grafana-1.london.cloud.service.gov.uk/d/5TM-xIoZk/andy-gorouter-noodling?orgId=1) and the [bosh jobs heatmaps cpu dashboard](https://grafana-1.london.cloud.service.gov.uk/d/0VvHu51nz/bosh-jobs-heatmaps-cpu?orgId=1&refresh=30s&var-environment=prod-lon&var-bosh_director=prod-lon&var-bosh_deployment=prod-lon&var-bosh_job_name=router&from=now-2d&to=now).

There are three time series displayed on Andy's dashboard: available capacity, required capacity and used capacity. The metric used for all the time series is `firehose_counter_event_gorouter_total_requests_total`. To get the `used capacity` the metric is divided by 80 because at the time it was assumed that each router instance was only capable of handling 80 requests per second. To get the `required capacity` the metric is multiplied by 1.3 and then the result is divided by 80. The metric is multiplied by 1.3 to provide a contingency of 30%.

The Cloud Foundry guidance on horizontally scaling routers says that the number of requests per second that was chosen for the benchmark test was used  `so that the router VM would hover at about 70% CPU usage`. The number of requests per second used was approximately 1,200. This is somewhat higher than the 80 requests per second assumed in Andy's noodle dashboard. What that means is that there is already contingency built into the PromQL queries of that Dashboard.

The `bosh  jobs heatmaps cpu dashboard` displays a Histogram and the drop-downs permit the bosh router job to be selected. At the time of writing the CPU System Usage Histogram was showing that the majority of the time the routers were using between 0 - 2% of CPU. Very occasionally a single router was using 15 - 16% CPU. It was a very similar story with the CPU User Usage Histogram although the usage was higher as might be expected. The majority of the time the routers were using 0-6% of the CPU.

It was found that the highest usage of a single router over the last 30 days was on the 27th Jan when 16% system + 20% user = 36% was used by a single router. That is far below the 70% ceiling advocated by Cloud Foundry.

There are 30 routers currently deployed in the prod-lon environment. Andy's dashboard with the built in contingency indicates that approximately eight routers are required to support the current workload. It is probably not a good idea to reduce the routers to the number indicated by Andy's dashboard in one PR. There could well be a disproportionate effect on the remaining routers. The reduction should be performed in stages. After each reduction the remaining routers should be monitored for a reasonable period using the two dashboards mentioned above. 