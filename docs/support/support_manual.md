
## What are we supporting

We are supporting the GOV.UK PaaS platform; we’re not providing user support for users of the apps hosted on it.
However, in some cases service teams can’t self diagnose or fix problems (yet) so we need to be flexible about what we support.

We’re supporting live services, teams who are using PaaS for prototyping and individuals within teams who are just trying it out.

## Support hours
* **In hours**: Monday to Friday 9am to 5pm
* **Out of hours - waking hours**	: 9am to 5pm each non-working day including weekends and bank holidays
* **Out of hours - overnight**: 5pm to 9am each day

## How we know what is going on
### What we monitor in hours

TO BE COMPLETED (e.g. Concourse build status, User impact dashboard + datadog dashboard, New support cases in deskpro/your mail).

### Alerting out of hours

These are the things we support out of hours:

* Apps no longer being served due to an issue with our platform
* Serious security breach on the platform
* Tenants are unable to push an emergency fix to an app due to the PaaS API not being available
* A Tenant’s live production app has a P1 issue which cannot be resolved without us

We expect to hear about the first two via the alerts on Smoke Test Fails and Pingdom which are sent to Pagerduty.

The second two, at the moment, are the things that a tenant may contact us about as we don’t cover all situations in which these could occur with our own alerting. They would contact us via our emergency email. This creates a P1 ticket in Deskpro and triggers Pagerduty.

## Triaging issues

An issue could be something which is raised through our monitoring, alerting, Deskpro or slack.

Triaging an issue is higher priority than other work. Once the issue has been triaged, it will be categorised (P1, P2 etc) and prioritised.

The following questions should be answered when triaging/prioritising:

* What’s the urgency and why?
* What’s the impact to our users, systems and reputation?
* What’s the extent of the issue, how many systems and users are affected?
* Is it a known issue - is there a workaround?
* If there is uncertainty about which classification an issue should be given, the PaaS Product manager, PaaS Technical Architect or Tech Lead will be responsible for making a final call.
* In the event that none of the above people are available, you should use the triage questions to make a decision based on the information you have at the time.

## Severity Levels
We classify issues by their impact to users (tenants and their users, and the PaaS team) and react accordingly. This allows us to set expectations about how we will work, and what other teams should expect.

For most types of issue, our priority is to ensure high availability of the service.

An incident is any issue which causes significant problems for many platform users. This will include all P1 issues, and some P2 issues.

The exceptions to this are for some categories of security breach or vulnerability, and for some incidents where there is a risk of data corruption.

*(Note this table is copied from overview doc - keep in sync. More detail may be needed later)*

| Classification | AKA | Example | In hours| Out of hours |
| --- | --- | --- | --- | --- |
| P1 | Critical Incident | <ul><li>Apps no longer being served due to an issue with our platform</li><li>serious security breach on the platform</li><li>You are unable to push an emergency fix to an app due to the PaaS API not being available</li><li>your live production app has a P1 issue which cannot be resolved without us</li></ul> | Start work & respond: 20 min<br/><br/> Update time: 1 hr | 40 mins |
| P2 | Major Incident |<ul><li>Can’t update/push apps due to platform issue</li><li>Upstream vulnerabilities</li><li>elevated error rates</li><li>Complete component failure</li><li>substantial degradation of service</li></ul>| Start work & respond: 30 min<br/><br/>Update time: 2 hr  | n/a |
| P3 | Significant | Users (tenants or end users) experiencing intermittent or degraded service due to platform issue.| Start work & respond: 2 hr<br/><br/> Update time: 4 hr  n/a |
| P4 | Minor | Component failure that is not immediately service impacting | Start work & respond: 1 business day <br/><br/> Update time: 2 business days | n/a |

## Support tickets
You can access our [support ticketing tool Deskpro here](https://gaap.deskpro.com/agent/)

If you don’t have an account ask Urmi to add you. You can adjust your notifications yourself.

### Tips and good practice

* Try to keep a descriptive name in the Deskpro cards. If the user added a not very descriptive name (e.g failure pushing app), change it to something that uniquely identifies the story (e.g failure pushing app: invalid mode 0444).
Always notify the tenant about this change and why it is done.
* Try to close the tickets if there is no action required from us.
* If we are waiting for a card in the backlog, add add note in the card to saying that we need to inform the user once is done and accepted.
* Always notify the user that we are closing it, why we are closing it and why the issue is resolved or it does not require more work from us.
* Let the user know that they can always reopen the ticket if required.

## Incident Process

This is now in its [own section](incident_process).

## Useful links

* [Deskpro](https://gaap.deskpro.com/agent/)
* [Pagerduty](https://gds-paas.pagerduty.com/)
* [Developer docs](https://government-paas-developer-docs.readthedocs.io/en/latest/)
* [Staging pipeline](https://deployer.staging.cloudpipeline.digital/)
* [Prod pipeline](https://deployer.cloud.service.gov.uk)
* [Prod metrics](https://metrics.cloud.service.gov.uk/dashboard/file/user-impact.json)
* [Prod logs](https://logsearch.cloud.service.gov.uk)
* [All pipelines dashboard](https://dsingleton.github.io/frame-splits/index.html?title=&layout=2row&url%5B%5D=https%3A%2F%2Fdeployer.staging.cloudpipeline.digital%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry&url%5B%5D=https%3A%2F%2Fdeployer.cloud.service.gov.uk%2Fteams%2Fmain%2Fpipelines%2Fcreate-cloudfoundry&url%5B%5D=&url%5B%5D=)
* [Monitor summary](https://paas-dashboard.cloudapps.digital/paas-overview)
* Fourth wall (PR dashboard): `https://alphagov.github.io/fourth-wall/?token=${GITHUB_API_TOKEN}&team=alphagov/team-government-paas-readonly` (insert github readonly account token)
