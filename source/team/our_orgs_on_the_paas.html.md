---
title: Our orgs on the PaaS
---

# Our orgs on the PaaS

We generally expect tenants to use a single org on the PaaS for their service.
We therefore want to follow the same guidlines for our own apps running on the
PaaS. As a result we avoid creating separate orgs for different things, and
split our apps into one of 2 orgs as follows:

## The `admin` org

This is for things that make up part of the platform itself. This includes
things like service-brokers, monitoring tools etc.

## The `govuk-paas` org

This is for things relating to our team. This includes our documentation, team
tools (eg rubbernecker) etc.
