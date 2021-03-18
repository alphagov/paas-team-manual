---
title: ADR024 - web app language and framework selection
---

# ADR024: web app language and framework selection

## Context

We are starting to develop a number of user-facing applications with web
interfaces that need to be GOV.UK branded. In order to keep things consistent
we want to pick a single programming language to write these in.

We've previously chosen Ruby on Rails as our desired framework in the previous
[ADR022]. And whether or not it was a right choice, we decided to revisit and
reconsider that choice.

The reason for that, is simply the direction GDS is heading at. It would appear
that old components will be soon deprecated and the Frontend Community has no
desire to support gems in the future. Saying that, we could have remain with
Rails and delegate the component management to NPM. This would however increase
the amount of possible maintenance work we would need to undertake, due to the
use of [nunjucks] by the Design System team.

We questioned the need of running Rails application for something that
essentially is a templating system for existing data and API.

After some more research, discussion with the head of the Frontend Community,
members of the team and some others in GDS, the better choice would be Node for
the following reasons:

* It's the way Frontend Community is heading at
* It will be easier to rotate/onboard Frontend Developers
* The initial applications are to be simple (thin layer between API calls and
  HTML parsing)
* It's light and essentially is JavaScript
* It supports [nunjucks] which will help us in maintenance

## Decision

We will use Node to create new user-facing applications that render a web
interface for our service but will not be used to implement any significant
‘application logic’.

## Status

Accepted.

## Consequences

We should consider porting some of our existing applications over to Node.

[nunjucks]: https://mozilla.github.io/nunjucks/
[ADR022]: /architecture_decision_records/ADR022-web_app_language_and_framework_selection/

