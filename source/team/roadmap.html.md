# GOV.UK PaaS public roadmap triaging

## Overview
Our public roadmap is a [GitHub project](https://github.com/alphagov/paas-roadmap/projects/1?fullscreen=true) in the [alphagov/paas-roadmap](https://github.com/alphagov/paas-roadmap]) repository

The roadmap is publicly visible on the internet, and it is intended for tenants and prospective tenants.

Tenants can make feature requests, suggest new services we might broker, and discuss and vote on existing issues. When a tenant makes a request via support, or otherwise expresses an unmet need, we should encourage them to document it in the 'Proposed' column of the roadmap.

We review the roadmap every month.
We aim to: 
-   triage the issues
-   respond to comments
-   retire any issues that aren't useful
-   ensure the board reflects reality (i.e. things being worked on are in 'Doing'). 

While new issues are responded to quickly, we will take them into account for more long term planning. 

## Adding items to the roadmap
We encourage users to engage with us by publishing an open and editable public roadmap.

If you have a need for a feature that doesn't exist on the platform and isn't currently planned then [you can submit a feature request](https://github.com/alphagov/paas-roadmap/issues/new/choose) as an issue through GitHub.

You can also read feature requests from other people on our roadmap, upvote the request or add your own comments.

There are macros available in ZenDesk for when support tickets about feature requests and we signpost people to the GitHub project
-   GOVUK PaaS::Feature request::Feature doesn't exist on roadmap
-   GOVUK PaaS::Feature request::Feature is on roadmap

The information we ask for when creating a feature request is:
-   Is your feature request related to a problem? Please describe.
-   Is this blocking you from doing anything?
-   Describe the outcome you'd like
-   Describe the solutions you've considered
-   Any additional context

We also signpost to evidence from support tickets and related pivotal stories on the feature card to help prioritise and show demand.

## Roadmap triage meetings
Every month we discuss the items on the public roadmap as a team. This session lets us discuss the roadmap in context of what else is going on in the team and our current workload.

### Standing agenda
  1. Review [new suggestions](https://github.com/alphagov/paas-roadmap/issues?q=is%3Aopen+is%3Aissue) (issues and/or comments) from tenants, add new issues to board using "Add card" and decide whether to do one of the following:
-   Add to 'proposed' column and to future mission planning considerations
-   Consider it as a candidate for the paas-community or a firebreak project (label it if so)
-   Add to [pivotal tracker backlog](https://www.pivotaltracker.com/n/projects/1275640) as a story for spiking or doing now/later
-   Close card if not relevant/possible or merge if request has already been raised or is being combined and respond to user

  2. Refine the roadmap: 
-   refine existing issues so that they are complete and intelligible to the team and tenants
-   provide labels and status updates to existing cards if applicable
-   review the order of the cards in 'proposed' so that it is more of less in order of priority i.e. 'what will be next'
-   discuss if any of the cards ready to move from 'proposed' to 'next' (or 'now') by considering:
    -   How important is it? 
    -   what problem is it solving?
    -   how much demand is there for it?
    -   what would add the most value?
    -   how does it align to our vision/use cases for GOV.UK PaaS?
-   What's the effort?
    -   how much development will this take?
    -   how complex is it?
    -   is it feasible?
    -   how much capacity do we have to work on it (this sprint/this quarter/this year)?
-   move any card left to right where necessary (i.e. from proposed > next > now > delivered)
-   close card if not relevant/possible or merge if request has already been raised or is being combined and respond to user

  3. Next steps:
-   anything that should be pitched for ad hoc and added from team
-   review output from sessions and agree owners of actions
-   anything that moves from 'proposed' to 'next'/'now' need to have stories/epics written for it and moved into PivotalTracker so we can add it to priorities in delivery and planning and later backlog refinement
