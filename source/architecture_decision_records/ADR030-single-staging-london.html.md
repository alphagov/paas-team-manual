# ADR030: Single staging environment in London


# Context

We run a Cloud Foundry platform in London (AWS eu-west-2 region) to satisfy GOV.UK PaaS tenant needs to host on UK soil. This is driven by regulatory compliance and the hosting needs of selected existing GOV.UK PaaS tenants who are making preparations for Brexit.

Longer term we will migrate tenants to the London region and demise the region in Ireland to further reduce our footprint.

In addition we need to responsibly manage our use of Amazon Web Service resources to reduce the ongoing running costs. Having duplicate staging environments doubles the amount of infrastructure and hence cost.

The London region is newer than the Ireland and offers a slightly reduced subset of services compared to the more mature Ireland region.

We feel the risks of running a single staging environment are offset by the cost savings and the reduction in footprint.



# Decision


We will demise the Ireland (eu-west-1) staging environment resulting in a single staging environment in AWS London.


# Status
Accepted

# Consequences
- Fewer moving parts and reduced infrastructure footprint.
- The change moves closer to our target of running our platform in London
- Reduce the cost of operation.
- Fewer environments and simplification of our pipelines.
- We will check that we are able to run our pipelines to deploy to Ireland and London.
- We will check the impact on our infrastructure usage.



