---
title: StatusPage
---

# StatusPage

The team uses [StatusPage.io](https://www.statuspage.io/) to notify our users of platform issues and maintenance windows. As this provides simple, clear and concise information related to the health and status of the platform. It also enables webhook access for tenants to link to Slack / HipChat / Link.

The Announce mailing list is to be used to announce new features and any resulting changes to tenants.

## Accounts

We have a team user for technical support of statuspage.io and for any issues that arise whilst on support. Its credentials are stored in the credentials repository.

We create individual users for those that will use it as a communication tool i.e. the Product and Delivery Managers. As they are not able to use the credentials store.


## What it shows

The banner section contains the Subscription button, subscriptions to updates are offered via email and webhooks.

The top status section (platform HTTPS and Platform Database) is currently manually updated and has the following status options;

- Operational
- Under Maintenance
- Degraded Performance
- Partial Outage
- Major Outage

Below this are uptime and response time graphs. These are taken directly from Pingdom's API.

Futher down the page is the incident log. This is also manually managed from the statuspage.io dashboard.

## Using Statuspage.io

Log in with your creds, this should take you to the dashboard.

From the dashboard you can manage incidents either using free text or templates and the status of each component via a drop down menu.

Full documentation is available at http://help.statuspage.io/help_center

### Incidents

Incidents are a group of things that are occurring, they describe the bigger picture e.g. "Unable to deploy" or "CDN is currently failing some requests".

The incident documentation is located at http://help.statuspage.io/knowledge_base/topics/incidents-overview

### Scheduled maintenance

We can use statuspage for notifying users of scheduled maintenance to the service. This has a similar workflow to creating and managing incidents. The full documation is located at http://help.statuspage.io/knowledge_base/topics/scheduled-maintenance

One of the key advantages is upon setting a maintenance window, subscribers to statuspage will be automatically notified 60 minutes before the window starts.

### Components
To communicate the state of each component, they always have one of the 5 following statuses:

- Operational
- Under Maintenance
- Degraded Performance
- Partial Outage
- Major Outage

You can change the state of your components from the Dashboard.

Documentation is available at http://help.statuspage.io/knowledge_base/topics/overview-1

## How it was setup

It was set up manually as we didn't have an API endpoint to hit until it had been created. This was a process of signing up using the details in the credentials repo.

Terraform manages the CNAME in Route53 in order for us to use a custom domain to host the page on.

CSS was copied from Notify's statuspage to give a consistant look and feel. This is as close as we can get to the toolkit within the limited options available.

## Future enhancements

- Driving the component status from smoke testing
- Adding the configuration into terraform to run as part of the pipelines
- Adding Platform API status to the page
