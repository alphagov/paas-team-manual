Some key information to help new starters to find their way.

# Product

The following blog posts and videos give an overview of why we're here and
what we've been doing so far:

- [A PaaS for Government - Anna at Velocity Europe (video)](https://www.youtube.com/watch?v=OLOaq-Xf5zU)
- [Building a platform to host digital services - Anna & Carl on the GDS blog](https://gds.blog.gov.uk/2015/09/08/building-a-platform-to-host-digital-services/)
- [Looking at open source PaaS technologies - Anna on the GDS Technology blog](https://gdstechnology.blog.gov.uk/2015/10/27/looking-at-open-source-paas-technologies/)
- [Choosing Cloud Foundry - Anna on the GaaP blog](https://governmentasaplatform.blog.gov.uk/2015/12/17/choosing-cloudfoundry/)

# Repos

These are the key repos that we use. There will be many others, which these
depend on, but this list should be enough to get you started.

- [alphagov/paas-cf](https://github.com/alphagov/paas-cf)
- [alphagov/paas-team-manual](https://github.com/alphagov/paas-team-manual)
- [alphagov/paas-credentials](https://github.com/alphagov/paas-credentials) (private)

# Accounts

You will need accounts to a number of tools/services that we use such as
GitHub and Pivotal Tracker. Government Digital Service staff can see a full
list and their respective URLs in the following spreadsheet:

- [PaaS Team Checks](https://docs.google.com/spreadsheets/d/14gEh9jILg2p9aVIS78WTKEYMsz-ltetxnbugIw4TrWA/edit#gid=228343062)

# Events

These are key events that happen each fortnightly sprint. You'll get
calendar invites that detail the actual times and locations.

- Stand-up is at 09:45 every morning. We'll talk briefly about progress,
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


# Hand Signals

We use hand signals at our meetings to help make them more productive and
accessible for every person on the team. You can find out more about how this
works in practice by reading [our blog post][].

[our blog post]: https://gds.blog.gov.uk/2016/10/07/platform-as-a-service-team-takes-even-handed-approach-to-meetings/

# Learning

We use a number of technologies and you may find it easier to learn about each
one on its own, rather than in our environment, where they all interact with
each other.

Here are some recommended exercises and documentation that will help you become
familiar with each one.

 What | Get started | Learn the concepts 
------|-------------|------------------------
Cloud Foundry, as a user | [Our getting started guide](https://docs.cloud.service.gov.uk) | [Considerations for application developers](http://docs.cloudfoundry.org/devguide/deploy-apps/prepare-to-deploy.html)
[Concourse](http://concourse.ci/), the CI server we use for deployment | [Concourse tutorials](https://github.com/starkandwayne/concourse-tutorial) | [Concepts](http://concourse.ci/concepts.html)
[BOSH](http://bosh.io/). It deploys Cloud Foundry and other things. | [A guide to using BOSH](http://mariash.github.io/learn-bosh/)  | [What problems does BOSH solve?](http://bosh.io/docs/problems.html) 
Cloud Foundry, for those managing it | | [Cloud Foundry presentation, written by the team](https://docs.google.com/presentation/d/1LkR4Y3jLBQ8uskKeLIyKtSKDoutnAvty-vSSGfVNXZU/view), an [older presentation from before the move to Diego archecture](https://docs.google.com/presentation/d/1sZH1Nn_GiYfpBtT6br_AnZn_dynLzvYizJ9aQ4Zc1Ww/view)
Terraform | The terraform [intro](https://www.terraform.io/intro/index.html) | The intro also covers key concepts.

