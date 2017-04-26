## CloudFoundry CVEs and Datadog

CloudFoundry has a [page dedicated to security](https://www.cloudfoundry.org/category/security/) where published CVEs are listed. They offer an [RSS feed](https://www.cloudfoundry.org/category/security/feed/) so alerting can be automated.

Datadog offers an [RSS integration](http://docs.datadoghq.com/integrations/rss/) that can monitor an RSS feed and create an event for each new published content. By combining it with the [event monitor](https://www.datadoghq.com/blog/event-alerts-another-way-to-trigger-notifications/) we can get notified for each new alert.

The RSS integration was set up manually as there is no [Datadog API](http://docs.datadoghq.com/api/) for that. The monitor is created via terraform. If triggered, it emails Deskpro to create a ticket for each new CVE.

## How to configure the RSS integration

1. Login to Datadog with an admin account
1. Go to [integrations](https://app.datadoghq.com/account/settings#integrations)
1. Locate the RSS integration and click to install (or configure if already installed)
1. Click on the `Configuration` tab
1. Configure the integration by entering:
    1. Feed URL: https://www.cloudfoundry.org/category/security/feed/
    1. Custom Tags: cve,service:pivotal
1. Click `Update configuration`

The new CVEs should now show up as events in Datadog.
