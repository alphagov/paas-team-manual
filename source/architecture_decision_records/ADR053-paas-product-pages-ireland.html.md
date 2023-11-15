---
title: ADR053 - Plan for maintaining product pages post Ireland retirement
---

# ADR0053: Plan for maintaining product pages post Ireland retirement

## Context

The [PaaS product pages](https://github.com/alphagov/paas-product-pages) is a static site that is currently deployed 
to GitHub pages accessible at both [www.cloud.service.gov.uk](https://www.cloud.service.gov.uk) and [cloud.service.gov.uk](https://cloud.service.gov.uk).

The current DNS configuration in Route 53 has a CNAME record for `www.cloud.service.gov.uk` which points 
to GitHub's servers and a CNAME record for `cloud.service.gov.uk` which points to the load balancer in the Ireland region.

A user that navigates to [cloud.service.gov.uk](https://cloud.service.gov.uk) is redirected to [www.cloud.service.gov.uk](https://www.cloud.service.gov.uk) 
as traffic for that domain is passed from the load balancer in the Ireland region via the GoRouter to an app which performs an HTTP redirect. 
The app is a nginx application that is currently deployed to the Ireland region with a route that maps to [cloud.service.gov.uk](https://cloud.service.gov.uk).

However once the Ireland region is decommissioned we will still need to perform an 
HTTP redirect from `cloud.service.gov.uk` to `www.cloud.service.gov.uk`. There are several ways of doing this.

## Options
### Option 1: CDN

This involves hosting a custom CDN instance using Amazon CloudFront as outlined in our [documentation](https://docs.cloud.service.gov.uk/deploying_services/configure_cdn/).  

Since `cloud.service.gov.uk` is an apex domain we cannot set a CNAME record nor do we know the IP addresses for the 
CDN instance up front. However, Amazon Route 53 provides a feature known as 'alias' records which are an extension to 
DNS that allows traffic to be directed to AWS resources. This allows the DNS query for `cloud.service.gov.uk` to 
resolve to the IP address of the CDN instance.

The `paas-product-pages-redirect` app will have to be deployed to the PaaS London region 
accessible at `paas-product-pages-redirect.london.cloudapps.digital`. The CDN instance will then need to be configured 
to modify the incoming `Host` header to `paas-product-pages-redirect.london.cloudapps.digital`. This allows the 
GoRouter to send the request to the redirect app.

### Option 2: ALB redirect

This involves creating an A record for `cloud.service.gov.uk` that points to the load balancer in the London region 
with a HTTP/s listener rule that performs an HTTP redirect to `www.cloud.service.gov.uk`.

Since the HTTP redirect is done by the load balancer the redirect app is unnecessary and can be deleted.

### Option 3: Private domain

This involves creating an A record for `cloud.service.gov.uk` that points to the load balancer in the London region with
`cloud.service.gov.uk` added to the Cloud Foundry deployment as a new private domain. 

The `paas-product-pages-redirect` app will be deployed in the London region accessible at `paas-product-pages-redirect.london.cloudapps.digital` 
with a route that maps to `cloud.service.gov.uk`.

### Option 4: DNS

This involves creating several A records for `cloud.service.gov.uk` that point towards the IP addresses for GitHub's servers 
outlined [here](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain).

Since both the `wwww` and apex domains resolve to GitHub's servers the redirect app is unnecessary and can be deleted.

## Decision

Consensus team decision is Option 4 as it involves only a DNS change. Since there are other DNS records (e.g. DMARC, etc...) 
for the `cloud.service.gov.uk` domain that need to be kept it makes sense to just make DNS changes in the Terraform.

## Status

Accepted

## Consequences

Users will be able to continue to access the product pages at `cloud.service.gov.uk`.