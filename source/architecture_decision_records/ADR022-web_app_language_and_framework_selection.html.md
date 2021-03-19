---
title: ADR022 - web app language and framework selection
---

# ADR022: web app language and framework selection

## Superceded

This has been superceded by [ADR024][] since February 2018. It has been retained for historical purposes.

------------------------

## Context

We are starting to develop a number of user-facing applications with web
interfaces that need to be styled to look like GOV.UK etc. In order to keep
things consistent we want to pick a single programming language and framework
to write these in.

We've previously used [Sinatra][] for this, but ran into
issues with its default configuration which isn't secure, leading to an XSS
vulnerability. We therefore want to choose something that comes with secure
defaults, and makes it easier to avoid this sort of issue.

Requirements:

* Must be well supported by [govuk_template][] and [govuk_frontend_toolkit][] (as
  well as the future [govuk-frontend][] project)
* Must be understood broadly by members of the team.
* Must be understood broadly by members of the frontend developer community within GDS.

After dicsussion with the head of the frontend community and members of the
team, the choice seems to be Rails for the following reasons:

* Most of www.gov.uk is written in Rails, as is the Verify frontend, and
  therefore is well known within the frontend developer community.
* It's well supported by the frontend toolkits (both projects are available as
  gems that provide a Rails engine). Given the wide use of Rails with GDS, the
  future [govuk-frontend][] project is likely to support it.
* It's the framework that's most familiar to our team.
* It is opinionated, and comes with secure defaults making it much easier to
  create a secure web app.

## Decision

We will use Ruby and Rails to create new user-facing applications with web frontends.

## Status

Superceded by [ADR024][].

## Consequences

We should consider porting some of our existing applications over to Ruby and Rails.

[ADR024]: /architecture_decision_records/ADR024-web-app-language-and-framework-selection-2
[Sinatra]: http://sinatrarb.com/
[govuk_template]: https://github.com/alphagov/govuk_template
[govuk_frontend_toolkit]: https://github.com/alphagov/govuk_frontend_toolkit
[govuk-frontend]: https://github.com/alphagov/govuk-frontend
