---
title: ADR050 - Plans for the cloudapps.digital domain post platform retirement
---

# ADR0050: Plans for the cloudapps.digital domain post platform retirement

## Context

GOV.UK PaaS has provided a [default domain for applications](https://docs.cloud.service.gov.uk/orgs_spaces_users.html#regions). It has always been part of the documentation and [using a custom domain](https://docs.cloud.service.gov.uk/deploying_services/use_a_custom_domain/) has been supported since the platforms inception.

The intention of the cloudapps.digital domain was that it gave tenants whilst in the development stages a way to quickly gain feedback on if the platform was right for their use case, and that live applications should not be hosted on it.

We are aware that some tenants have used this domain for non development purposes

The technical method of how subdomains of cloudapps.digital have been registered is that the wildcard for cloudapps.digital points to GOV.UK PaaS. On the PaaS [route registrar](https://github.com/cloudfoundry/route-registrar) is a running daemon that accepts requests from the Cloudfoundry API to broadcast routes to [gorouter](https://github.com/cloudfoundry/gorouter) to match inbound traffic to subdomains of cloudapps.digital and to custom domains.

As this method is part of the platform itself, there is no standalone method of maintaining domain routing information. Once the platform is decommissioned this will no longer function.

## Decision

As there is no standalone method for managing domains outside of the platform, it is not possible to offer this as an ongoing service to tenants

As there has been some use of the cloudapps.digital domain in non-developmental application hosting, the domain should not be left to lapse and should be transferred to GOV.UK 2nd Line to join the domains that they keep on retention for protective purposes.

## Status

Accepted

## Consequences

Tenants will need to purchase a new suitable domain or leverage an existing one run by the department. We would encourage them to do this as soon as possible.

Once a new domain is purchased we would advise that the new [domain is used as a custom domain](https://docs.cloud.service.gov.uk/deploying_services/use_a_custom_domain/) and that the tenant sets up a [redirect can be run on the platform](https://docs.cloud.service.gov.uk/managing_apps.html#redirecting-all-traffic) to ease the transition to the new domain.

By transferring the domain to join the others on retention, the abuse of the domain for phishing etc by a malicious third party is mitigated.
