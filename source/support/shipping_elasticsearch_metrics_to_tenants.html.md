# Shipping Elasticsearch metrics to our tenants

As of July 2020 we provide Elasticsearch metrics to several tenant
Prometheuses. This is an informal "alpha" and only on an in-hours,
best-effort basis.

## How it works

![Diagram of the alpha Elasticsearch Prometheus exporter](/diagrams/elasticsearch-metric-exporter-alpha.jpg)

Aiven already provide a Prometheus endpoint on every Elasticsearch
node, but there are 3 problems with tenants using that:

  - tenants don't know how to find the endpoints

  - we can't give tenants the necessary credentials

  - an IP safelist stops any Prometheus outside PaaS from scraping the
    endpoints.

We deploy a PaaS app running both `aiven-service-discovery` and
Prometheus. `aiven-service-discovery` emits a list of all the
endpoints to scrape. The Prometheus scrapes those endpoints. Tenants
then federate to their own Prometheus (i.e., have their Prometheus
scrape the `/federate` endpoint.)

We deploy one per tenant, behind a basic auth route service. These
apps and route services are in the `admin / monitoring` space of
Ireland and London.

One issue is that we have to manually list the Elasticsearch service
instances and include a list of them in the app. So if tenant creates
a new Elasticsearch instance it won't receive metrics unless we update
the app manually. Fixing this is left until it's less of an alpha.

The code and manifests are in [a PR on `alphagov/paas-observability-release`](https://github.com/alphagov/paas-observability-release/pull/5).

## If something goes wrong

Don't worry. This is an informal "alpha" and only on an in-hours,
best-effort basis.

Ideas for debugging:

  - Access the Prometheus using the credentials from `cf env` on the
    route service app
    - See if it is still receiving metrics
    - Look at the Targets page and see whether it is still scraping
      data from all the tenant's Elasticsearch nodes
  - Look at the Elasticsearch services in Aiven and see if you can
    make metrics requests manually (use `cf ssh` so your requests come
    from the PaaS IP ranges)
  - Talk to Aiven support
  - Ask Miki or Andy for help (we worked on it originally)

## How to set it up for a new tenant

Checkout the code from [github.com/alphagov/paas-observability-release/pull/5](https://github.com/alphagov/paas-observability-release/pull/5) and make a copy of one of
the existing manifests.

Next you need to make a JSON file listing all their service instances
and some metadata that will be turned into Prometheus metric labels.
Unfortunately we don't have a script for this yet. Here's an example:

```
[
  {
    "aiven_service": "${DEPLOY_ENV}-${SERVICE_INSTANCE_GUID}",
    "extra_labels": {
      "service_guid": "${SERVICE_INSTANCE_GUID}",
      "service_name": "${SERVICE_INSTANCE_NAME}",
      "space_guid": "${SPACE_GUID}",
      "space_name": "${SPACE_NAME}",
      "org_guid": "${ORG_GUID}",
      "org_name": "${ORG_NAME}"
    }
  },
  …
]
```

Save that list in the same directory as the manifest and alter
`SERVICES_FILE` in the manifest to be named appropriately.
Also alter the rest of the manifest so that its names match your
tenant.

Now it's time to deploy. `cf push` the manifest using `--var` to
provide values for the Aiven secrets it requires. You can get those
values from an existing app or our credential stores.

Visit the app URL and you should see a Prometheus interface. Check its
Targets page and you should see it scraping data from all the nodes of
the Elasticsearch services you configured in the JSON file. Check the
metric graphs look sensible (you can compare them to ones in Aiven's
interface.)

Once that's working OK it's time to deploy a basic auth service in
front of the app. Our public documentation says how to do that.

Finally you need to help the tenant configure their Prometheus. By
default there are 700-ish different metrics reported, and tenants
probably don't want to saturate their Prometheus with that much data.
We have an [example Prometheus config](https://gist.github.com/46bit/bbc7f267f6115fc008c9ddb43cd56745)
and a [spreadsheet showing what metrics are available](https://docs.google.com/spreadsheets/d/1LffFBhe5T937MF0vYQWSH4j10niZS7IImlUAW4cYiNE/edit#gid=0).
