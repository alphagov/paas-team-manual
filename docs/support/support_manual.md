Support manual is [currently hosted on Google docs](https://docs.google.com/document/d/1Ui0MQtZbZnRCIj4RUdqCPU6PdWvfqY9FNf7Ou3OE99w)

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

### Alerting out of hours

These are the things we support out of hours:

* Apps no longer being served due to an issue with our platform
* Serious security breach on the platform
* Tenants are unable to push an emergency fix to an app due to the PaaS API not being available
* A Tenant’s live production app has a P1 issue which cannot be resolved without us

We expect to hear about the first two via the alerts on Smoke Test Fails and Pingdom which are sent to Pagerduty.

The second two, at the moment, are the things that a tenant may contact us about as we don’t cover all situations in which these could occur with our own alerting. They would contact us via email: gov-uk-paas-emergency@gaap.deskpro.com. This creates a P1 ticket in Deskpro and triggers Pagerduty.

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
We classify issues by their impact to users (tenants and their users, PaaS team) and react accordingly. This allows us to set expectations about how we will work, and what other teams should expect.

For most types of issue, our priority is to ensure high availability of the service.

An incident is any issue which causes significant problems for many platform users. This will include all P1 issues, and some P2 issues.

The exceptions to this are for some categories of security breach or vulnerability, and for some incidents where there is a risk of data corruption.

*(Note this table is copied from overview doc - keep in sync. More detail may be needed later)*

| Classification | AKA | Example | In-hours| OOH overnight TBD (suggest) |
| --- | --- | --- | --- | --- |
| P1 | Critical Incident | <ul><li>Apps no longer being served due to an issue with our platform</li><li>serious security issue with the platform</li><li>your live production app has a P1 issue which cannot be resolved without us</li></ul> | Start work & respond: 20 min<br/><br/> Update time: 1 hr | 40 mins |
| P2 | Major Incident |<ul><li>Can’t update/push apps due to platform issue</li><li>Upstream vulnerabilities</li><li>elevated error rates</li><li>Complete component failure</li><li>substantial degradation of service</li></ul>| Start work & respond: 30 min<br/><br/>Update time: 2 hr  | n/a |
| P3 | Significant | Users (tenants or end users) experiencing intermittent or degraded service due to platform issue.| Start work & respond: 2 hr<br/><br/> Update time: 4 hr  n/a |
| P4 | Minor | Component failure that is not immediately service impacting | Start work & respond: 1 business day <br/><br/> Update time: 2 business days | n/a |

## Support tickets
You can access our [support ticketing tool Deskpro here](https://gaap.deskpro.com/agent/)

If you don’t have an account ask Urmi to add you. You can adjust your notifications yourself.

### Tips and good practice

* Try to keep a descriptive name in the deskpro cards. If the user added a not very descriptive name (e.g failure pushing app), change it to something that uniquely identifies the story (e.g failure pushing app: invalid mode 0444).
Always notify the tenant about this change and why it is done.
* Try to close the tickets if there is no action required from us.
* If we are waiting for a card in the backlog, add add note in the card to saying that we need to inform the user once is done and accepted.
* Always notify the user that we are closing it, why we are closing it and why the issue is resolved or it does not require more work from us.
* Let the user know that they can always reopen the ticket if required.

## Incident Process
This section covers incidents and outages where the priority is to ensure HA service, it gives an overview of what you should be aware of before you are faced with an incident.

*Triaging and responding to security vulnerabilities is below [TODO]*

### If we’re having an incident.

1. Nominate an incident lead (this may be you)
2. Nominate an incident comms person (during OOH this can be the person on the PaaS escalation rota)
3. Join #paas-incident on Slack
4. Get on with understanding and fixing the issue

The incident lead, comms and anyone else needed to work on the incident will form the incident team.

The incident team can request support from any other members of the PaaS team and fixing the incident is usually more important than routine meetings (1 to 1s, retrospectives, planning, etc).

### If you’re the incident lead:

Start making notes of what you’re doing - the #paas-incident Slack channel is the best place for this - so that the incident comms can start putting them in the incident report. Note, slack messages can start to disappear after a few days.

Decide if you need people to help, and ask for them to come over and sit with you. Many people can investigate at the same time, but only the incident lead should be making changes to production.

Consult the product manager and delivery manager to decide when the matter is not longer impacting the service, and is therefore resolved, or can be downgraded

Create a pivotal story to track our response to the incident. This should be used to keep a record of what we do to resolve the problem.

Ensure that we schedule the post mortem and publish our incident report Draft the incident report using the information that has been noted on slack. There is a [template](https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/155yrsyhHM9Feh-ucxLzyj7toIb2sMK8KiGVdEFLcyfQ/edit?usp=sharing) for this which also contains guidance, and there are examples [here](https://drive.google.com/drive/folders/0B5fiQJfQc7tRUVBTcjVfTFhVWUU?usp=sharing).

### If you’re incident comms:

1. Let the PaaS team know on #the-government-paas Slack channel
2. Send a summary of the incident as soon as possible to the [GaaP incidents email list](gaap-incidents@digital.cabinet-office.gov.uk) (this tells the GaaP team and a few others - internal to GDS - includes IA team members). See the instructions below for what to include.
3. Send a summary of the incident to our tenants. For guidelines follow instructions under [Notifying tenants](https://government-paas-team-manual.readthedocs.io/en/latest/team/notifying_tenants/)
4. Update tenants hourly using the instructions above.
5. Update the [PaaS status page](https://status.cloud.service.gov.uk/) by logging into [Statuspage.io](https://manage.statuspage.io/pages/h4wt7brwsqr0)
6. Ensure that all decisions/comms are in the timeline of the incident report.

[PaaS Emergency contacts and escalations document](https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/1_6zxOjvwY-zrf1D8eDNT9AeRhlcPAocBhC8dmHfRw0Y/edit?usp=sharing) *(restricted access)* provides useful contact information for escalations for out of hours support.

## When the incident is over

### Incident Report
The [incident report template](https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/155yrsyhHM9Feh-ucxLzyj7toIb2sMK8KiGVdEFLcyfQ/edit?usp=sharing) gives some guidance about how to complete it.

The incident lead and incident comms should ensure that the report is completed and that all relevant details are in the timeline.

### Incident Review meeting

This is a no-blame retro of the incident. See [blameless postmortems](https://codeascraft.com/2012/05/22/blameless-postmortems/) for some background.

The purpose of the meeting is to agree on what happened, to ensure the record fully reflects this, and to agree all follow-up actions. It should be held within a few days of the incident being resolved.

Invite the people from the team who were involved (Incident Lead/Comms/Team who worked on it) and if they are not on the list already, add the Delivery manager, Product Manager and Tech Arch.

### Publishing the Incident Report
[Some background](https://www.pivotaltracker.com/n/projects/1275640/stories/121574573).

Tell the GaaP comms team (Nettie Williams) as soon as possible that there may be a report to publish.

### Deciding to publish
This decision should be made by two of DM/PM/TL/TA.
By default we publish Incident Reports on the [GaaP Blog](https://governmentasaplatform.blog.gov.uk/) unless there is a good reason not to. This approach is consistent across Data Group - it is similar to how GOV.UK publishes its reports. It sets a good example and demonstrates openness, which is a good thing. We just need to make sure we consider any negative ramifications.

The only incidents for which this is not automatically true are for security incidents which need to be carefully considered in order to ensure that no further harm could be caused by publishing these.
### Editing for publication

Create a copy of our factual incident report which can be edited for publication and send it to Nettie in the GaaP comms team.

The GaaP comms team will edit to ensure it is suitable for the audience. This will include our users who are often developers, and will also include non-tech people. The comms team will want to pair with a member of the PaaS team on this rewrite, and have it fact checked. This could be PM/DM/TA/TL or someone that they suggest.
The comms team will agree publication with the cabinet office press office.

## Escalations
If there is a P1 incident, the GaaP team will have been informed via the GaaP incidents email list, and will be kept updated via the PaaS Announce email list.

If an incident needs to be escalated beyond the PaaS team, the incident comms person will contact people in the following order:

* GaaP Programme Director
* GaaP Programme Team

The person contacted above will decide if they need to alert a member of the GDS executive group. If none of the above are available then they will try the people below in the following order:

* David Lewis - Director for GDS Portfolio Group

The contact details above information as well as useful contacts can be found in
[PaaS Emergency contacts and escalations (restricted access)](https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/1_6zxOjvwY-zrf1D8eDNT9AeRhlcPAocBhC8dmHfRw0Y/edit?usp=sharing)

## Useful links

* [Deskpro](https://gaap.deskpro.com/agent/)
* [Pagerduty](https://gds-paas.pagerduty.com/)
* [Developer docs](https://government-paas-developer-docs.readthedocs.io/en/latest/)
* [CI pipeline](https://deployer.master.ci.cloudpipeline.digital)
* [Staging pipeline](https://deployer.staging.cloudpipeline.digital/)
* [Prod pipeline](https://deployer.cloud.service.gov.uk)
* [Prod metrics](https://metrics.cloud.service.gov.uk/dashboard/file/user-impact.json)
* [Prod logs](https://logsearch.cloud.service.gov.uk)
* [All pipelines dashboard](http://dsingleton.github.io/frame-splits/index.html?title=&layout=3row&url%5B%5D=https%3A%2F%2Fdeployer.master.ci.cloudpipeline.digital%2F&url%5B%5D=https%3A%2F%2Fdeployer.staging.cloudpipeline.digital%2F&url%5B%5D=https%3A%2F%2Fdeployer.cloud.service.gov.uk%2F&url%5B%5D=)
* [Monitor summary](https://paas-dashboard.cloudapps.digital/paas-overview)
* Fourth wall (PR dashboard): https://alphagov.github.io/fourth-wall/?token=${GITHUB_API_TOKEN}&team=alphagov/team-government-paas-readonly&github.gds_token=${GITHUB_GDS_API_TOKEN}&github.gds_team=government-paas/read-only (insert github readonly account tokens)
