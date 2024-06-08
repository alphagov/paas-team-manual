---
title: Orientation
---

# Orientation

Some key information to help new starters to find their way.

## Product

The following blog posts and videos give an overview of why PaaS was built and what it was used for:

- [A PaaS for Government - Anna at Velocity Europe (video)](https://www.youtube.com/watch?v=OLOaq-Xf5zU)
- [Building a platform to host digital services - Anna & Carl on the GDS blog](https://gds.blog.gov.uk/2015/09/08/building-a-platform-to-host-digital-services/)
- [Looking at open source PaaS technologies - Anna on the GDS Technology blog](https://gdstechnology.blog.gov.uk/2015/10/27/looking-at-open-source-paas-technologies/)
- [Choosing Cloud Foundry - Anna on the GaaP blog](https://governmentasaplatform.blog.gov.uk/2015/12/17/choosing-cloudfoundry/)

## Decomission Decision

The Government Digital Service (GDS) provided GOV.UK PaaS since 2015, supporting and providing a public cloud platform for departments using a shared hosting and responsibility model.
Following an extensive analysis period, GDS has concluded that, while the platform has been successful in its aims, the underlying technology would now require investment before it could meet its goals in the long term.
Faced with this need for re-investment GDS has decided to decommission the platform, in order to focus its budget and energy on other GDS products for common use by Government.
GDS will not be providing a replacement hosting service.


## Repos

These are the key repos that we use. There will be many others, which these
depend on, but this list should be enough to get you started.

- [alphagov/paas-cf](https://github.com/alphagov/paas-cf)
- [alphagov/paas-team-manual](https://github.com/alphagov/paas-team-manual)
- [alphagov/paas-credentials](https://github.com/alphagov/paas-credentials) (private)

## Accounts

You will need accounts to a number of tools/services that we use such as
GitHub and Pivotal Tracker. Government Digital Service staff can see a full
list and their respective URLs in the following spreadsheet:

- [PaaS Team Checks](https://docs.google.com/spreadsheets/d/14gEh9jILg2p9aVIS78WTKEYMsz-ltetxnbugIw4TrWA/edit#gid=228343062)

## Buddys for new engineers

If you're a new developer or SRE you'll be paired with a buddy for the first
few days. They'll help you get set up, explain the GOV.UK PaaS product in more
detail and help you get started implementing your first stories.

## Events

These are key events that happen each fortnightly sprint. You'll get
calendar invites that detail the actual times and locations.

- Stand-up is at 10:00 every morning. We'll talk briefly about progress,
blockers, and pair rotation. Please be on time and keep it succinct. There
is time for more detailed conversations immediately afterwards.
- Planning is at the beginning of a sprint. Most of the stories
will already be prioritised in the backlog and we don't do sizing. We'll
talk about what's coming up and anything that we've missed.
- Retrospective is at the end of a sprint. It's an opportunity to talk about
  what went well and what we can improve as a team. We use this [trello
board](https://trello.com/b/OlZbgdD9/paas-team-retro) to suggest things to talk
about and record actions.
- Knowledge share is at the end of a sprint. It is to share what we've learned
  during the sprint, including technical detail. During the sprint, try to
record things you want to hear more about or talk about in this [trello
board](https://trello.com/b/dxThHq4T/team-knowledge-share) and one or two
people present each, preferably with a demo.

### Late for Standup

Scary. Turning up late for the standup? How could such a thing happen.

Missing standup, or being late, means you will miss out on updates on:

* Team News (who is where today)
* Product News (any significant developments worth knowing about)
* Context on Work in Progress

The last one is especially important, as the standup is a valuable way to crowdsource ideas on problems that people may be having with a story, and if you are not there, you can't help.

### Absences

It’s important that we have cover within the team to mitigate issues during work hours within the agreed SLAs (20 minutes response time for P1s; which means any new alert must be acknowledged and ideally triaged within 20 minutes. Therefore, there must always be someone covering support.
Due to the size of the team, this needs active coordination from the team. To ensure this, the team have adopted the following team norms:

* Only one PaaS SRE can be on annual leave at a time
* Another PaaS SRE can be on learning time, but must still be available for support (so self-learning is fine, but a conference would not be)
* Lunch breaks should be staggered

The managed service pool provide additional capacity for support cover when the PaaS SREs are unavailable, for example due to an unplanned absence coinciding with some annual leave. The Managed Service Delivery Manager is responsible for ensuring there is appropriate cover in place at all times, and so all Leave requests must be approved by them.

* This is the level of notice we expect when you take leave:
* For 1 day – you must give at least 3 days notice
* For 2 days – you must give at least 1 week notice
* For between 3 days - 4 days – you must give at least 2 weeks notice
* For between 1 week - 2 weeks – you must give at least 4 weeks notice
* For greater than 2 weeks – you must give 3 months notice


## Learning our technologies

We use a number of technologies and you may find it easier to learn about each
one on its own, rather than in our environment, where they all interact with
each other.

Here are some recommended exercises and documentation that will help you become
familiar with each one.

 What | Get started | Learn the concepts
------|-------------|------------------------
# Cloud Foundry, as a user | [Our getting started guide](https://docs.cloud.service.gov.uk) | [Considerations for application developers](http://docs.cloudfoundry.org/devguide/deploy-apps/prepare-to-deploy.html)
# [Concourse](http://concourse-ci.org/), the CI server we use for deployment | [Concourse tutorials](https://github.com/starkandwayne/concourse-tutorial) | [Concepts](http://concourse-ci.org/concepts.html)
# [BOSH](http://bosh.io/). It deploys Cloud Foundry and other things. | [A guide to using BOSH](http://mariash.github.io/learn-bosh/)  | [What problems does BOSH solve?](http://bosh.io/docs/problems.html)
# Cloud Foundry, for those managing it | | [Cloud Foundry presentation, written by the team](https://docs.google.com/presentation/d/1LkR4Y3jLBQ8uskKeLIyKtSKDoutnAvty-vSSGfVNXZU/view), an [older presentation from before the move to Diego archecture](https://docs.google.com/presentation/d/1sZH1Nn_GiYfpBtT6br_AnZn_dynLzvYizJ9aQ4Zc1Ww/view)
# Terraform | The terraform [intro](https://www.terraform.io/intro/index.html) | The intro also covers key concepts.

[our blog post]: https://gds.blog.gov.uk/2016/10/07/platform-as-a-service-team-takes-even-handed-approach-to-meetings/

## Inclusive language

Diversity is important to us, as is inclusivity. To help create such an
atmosphere we avoid the use of certain words.

### Avoid gender-specific words

Gender-specific words like these can act to exclude other groups of people:

* guys
* gents
* chap
* man
* he
* girls

There is a great write up on the word [guys by Julia
Evans](http://jvns.ca/blog/2013/12/27/guys-guys-guys/) that helps explain why
it isn't quite gender neutral.

Words such as _everyone_, _folks_ or _team_ can be more inclusive.
[The first rule of devops club by Bridget Kromhout](http://bridgetkromhout.com/blog/2014/11/03/the-first-rule-of-devops-club/) is a great reference.

### Avoid assuming expertise

Some words assume expertise and can belittle others contributions:

* just
* obviously
* trivial

For example, using the word obviously can be a form of
[Hindsight Bias](https://en.wikipedia.org/wiki/Hindsight_bias): some
people reading this may know it, but others may not. Not so obvious right?

If this language is used widely it can stop people contributing to discussions.
It can make asking questions scary. This is bad.

Another problem with these set of words is that it can lead to underestimation
of effort by the team when effort is played down.

### Avoid treating people as resources

| Anti People |
|---	|---	|---	|---	|
| Resource(s) | &nbsp; | &nbsp; | &nbsp; |

Classic Management 1.0 speak, reducing people to Resources. We should not be
doing this.

> Our thoughts shape our language, but our language also shapes our thoughts.
> The zeroth step in creating humane workplaces is to start talking about the
> people not resources.
>
> [Esther Derby](http://www.estherderby.com/2010/12/resources-dont-write-software-people-do.html)
