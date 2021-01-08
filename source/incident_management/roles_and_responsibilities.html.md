# Support roles and responsibilities

What each role does on support and when it's needed.

You can refer to [Incident Process](/incident_management/incident_process/) for information on How to manage incidents and incident communication.

## Rota

The support rota is on [Pagerduty](https://governmentdigitalservice.pagerduty.com/schedules).

We have four rotas; in hours engineering, in hours comms, out of hours engineering and out of hours comms.

Our escalation rota is [GaaP SCS Escalation] (https://governmentdigitalservice.pagerduty.com/schedules#PE6NQ9Z).

If you are the engineer on support, add your shift onto the #paas slack channel description so your colleagues can see who is on support and that you are currently looking at the issue. If you need to swap shifts, ask your colleagues if they can swap or cover, then [update Pagerduty using an override](https://support.pagerduty.com/hc/en-us/articles/202830170-Creating-and-Deleting-Overrides).


## In hours engineering support role and responsibility
The in hours support lead is responsible for:

* monitoring system alerts and system health
* recording the number and nature of build fails on pivotal (label: fixing the build) so we can identify higher impact/frequency ones
* ensuring that each ticket in ZenDesk is picked up and responded to appropriately
* initial triage - providing or confirming the initial assessment of priority - there may be some discussion with the initiator (tenant) required here to clarify impact.
* involving other people as needed - supported by the delivery or product manager
* assigning an incident lead if the item is an incident.
* picking up ‘small tasks’ in Pivotal if there is time in between support tasks
* having a support handover meeting at the beginning and end of the support week

When you need to take a break for lunch or essential meetings etc, make sure you tell people ahead of time, and arrange for a colleague to cover for you. All other members of the team are responsible for providing assistance to the support person as needed. If you don’t feel comfortable asking your colleagues, talk to the delivery manager or team lead who can help.


## Out of hours engineering support role and responsibility

The out of hours support engineer is responsible for:

* Responding to system alerts which will be sent to you via pagerduty. These will only be things which seriously impact the availability of live services due to a problem with our platform.
* Responding to notification from tenant teams of P1 issues they are having which are caused by problems with the PaaS. This will also be via Pagerduty.
* Looking at the issue and telling the initiator that you are doing so (if initiated by a human).
* Doing what is needed to ensure the platform is available, not necessarily fixing or diagnosing the root cause.
* Alerting the communication escalation person if they feel they need support with putting out tenant comms.
* Involving other people if needed. NO HEROICS, do not deploy if unsure. Some things are not a one-person-decision.

For out of hours similar guidelines apply, if you need cover for an hour or two or an evening (e.g. for an appointment, or a family dinner), you need to agree this in advance with a colleague who can cover for you, and [update Pagerduty using an override](https://support.pagerduty.com/hc/en-us/articles/202830170-Creating-and-Deleting-Overrides).

On a Bank Holiday, we create a daytime override on the out-of-hours schedule so there is someone on the rota during Bank Holiday daytime. This person is usually the current out-of-hours person. We also create an override on the in-hours schedule to ensure that any alerts go to PaaS team email rather than the in-hours person.

## In hours comms lead role and responsibility

* Checks the on call engineer is ok and finds out if they need any additional support.
* Responsible for any communications (internal or external) required throughout the duration of the incident.
* Protects the support engineer from unnecessary distractions or questions.
* Opens an incident template with view permissions to all GDS staff. Posts it in #paas-incident channel.
* Records a timeline of events through the incident.
* Drafts and sends regular updates to tenants via Statuspage.

## Out of hours comms lead role and responsibility

* Checks the on call engineer is ok and finds out if they need any additional support.
* If more support is required, attempt to contact others from team (or GDS). Get help from the GaaP SCS Escalation person with this if needed.
* In the case of a P1 incident, or if any additional support is required, contact the person on duty on the [GaaP SCS Escalation rota] (https://governmentdigitalservice.pagerduty.com/schedules#PE6NQ9Z).
* Responsible for any communications (internal or external) required throughout the duration of the incident.
* Protects the support engineer from unnecessary distractions or questions.
* Opens an incident template with view permissions to all GDS staff. Posts it in #paas-incident channel.
* Records a timeline of events through the incident.
* Drafts and sends regular updates to tenants via Statuspage.


## GaaP SCS Escalation role and responsibility
If the out of hours 1st line support has decided that they need help with tenant communications so they can focus on fixing the issue, you should contact the person on the [GaaP SCS Escalation rota] (https://governmentdigitalservice.pagerduty.com/schedules#PE6NQ9Z). They will then be responsible for:

* Making decisions and assisting with tenant communications (if appropriate). This includes Slack [#paas-incident](https://gds.slack.com/messages/CAD4W35KK) channel, and [Statuspage](/team/statuspage/).
* To provide leadership-level backup for engineers if an incident requires leadership decision making or a broader response involving updating comms or activating other engineers.


You can find more information on the PaaS [incident Process](/incident_management/incident_process/#incident-process).
