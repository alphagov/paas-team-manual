# Incident Process

This section summarises :

- how to manage incidents and outages to ensure a highly available service
- how to manage incident comms

**If you suspect a security breach, [alert Information Assurance (IA) immediately](/support/responding_to_security_issues/#if-you-suspect-a-security-breach)**

## Set up the incident team

When an incident happens, the person on support must:

- nominate an incident lead; this person must have production access, and be the person on support
- nominate an incident comms person; during out-of-hours this can be the person on the PaaS escalation rota
- join #paas-incident on Slack if required

The incident lead, incident comms person and anyone else needed to work on the incident will form the incident team.

Incident team leads can request support from any other members of the PaaS team. Incidents take priority over BAU, for example retrospectives or planning sessions.

## Investigate and resolve the incident

Your incident responsibilities depend on your role within the incident team.

### Incident lead

1. Investigate the incident, requesting help from PaaS team if required.

1. Make necessary changes to the production environment (only the incident lead can do this).

1. Record actions taken and changes made in the #paas-incident slack channel.

1. Discuss the incident with the PaaS product and delivery managers to decide when the incident is resolved, or can be downgraded as it is no longer impacting the service.

As a lower priority, create a pivotal story to record all actions taken and changes made to resolve the incident

### Incident comms

1. Let the PaaS team know about the incident on the #paas Slack channel.

1. Notify the tenants about the investigation by creating a new incident in [Statuspage](https://team-manual.cloud.service.gov.uk/team/statuspage/) using the “Possible issue being investigated” template. 

    When creating or updating an incident, you must tick the boxes to say which components are affected, otherwise notifications will not be sent.

1. Update tenants hourly using the [saved templates](https://manage.statuspage.io/pages/h4wt7brwsqr0) in our Statuspage account.

## Escalations

You can escalate incidents within the GOV.UK PaaS team.

1. Go to [PagerDuty](https://gds-paas.pagerduty.com/services).

1. Go to __Configuration__ and select __Schedules__.

1. Check who is currently on the escalation rota.

1. Go back to __Configuration__ and select __Users__.

1. Select the relevant person to find their phone number.

If you need to escalate an incident beyond the GOV.UK PaaS team, contact these people in the following order:
- TechOps Programme Director
- Head of Reliability Engineering

The person contacted will decide if they need to alert a member of the GDS executive group. 

If neither the TechOps Programme Director nor the Head of Reliability Engineering are available, you must contact the Director for GDS Portfolio Group.

The contact details for the above people, as well as useful contacts, can be found in [PaaS Emergency contacts and escalations (restricted access)](https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/1_6zxOjvwY-zrf1D8eDNT9AeRhlcPAocBhC8dmHfRw0Y/edit?usp=sharing)

## When the incident is over

When the problem has been fixed, check that our [status page](https://status.cloud.service.gov.uk/) is showing that the PaaS is operational.

### Write the incident report

The incident lead and incident comms must write the incident report, ensuring that all relevant details, decisions and comms are in the timeline section of the report.

The [incident report template](https://docs.google.com/a/digital.cabinet-office.gov.uk/document/d/155yrsyhHM9Feh-ucxLzyj7toIb2sMK8KiGVdEFLcyfQ/edit?usp=sharing) provides guidance about how to complete it.

### Hold an incident review meeting

Conduct a [no-blame retro](https://codeascraft.com/2012/05/22/blameless-postmortems/) of the incident within one week of resolving the incident to:

- agree on what happened
- ensure the record fully reflects this 
- agree all follow-up actions 

Invite the following people:

- Incident Lead
- Incident Comms
- Incident team
- Delivery manager
- Product Manager
- Technical Architect

### Publish the incident report

Incident comms creates a version of the incident report for publication. Refer to the [template](https://drive.google.com/open?id=1g2_KVXfZnBDVFFlxyModAi8YSbF0uun32Z1Pe5TYBc8) for guidance, and also see previous examples.

By default we publish Incident Reports on Statuspage unless there is a good reason not to. It sets a good example and demonstrates openness. 

The only incidents for which this is not automatically true are for security incidents which need to be carefully considered  to ensure that no further harm could be caused by publishing these.

## Suppliers

### AWS

We have a full support contract with AWS. Open a support case through the AWS console or at https://aws.amazon.com/support. If the incident is ‘critical’ or 'urgent’ severity, use __click to chat__ or __click to call__ for immediate contact. 

### Aiven Elasticsearch

Aiven monitors its services 24 hours a day 365 days a year, and provides free email support regarding problems using and accessing its services. Aiven personnel:

- are automatically alerted on any service anomalies

- rapidly address any issues in system operations requiring manual intervention

Responses are provided on a best-effort basis during the same or next business day. Email [support@aiven.io](mailto:support@aiven.io) for all support requests.

### DataDog

We do not currently have dedicated support for datadog. You can use live chat to contact DataDog between 15:00 and 00:00 UTC, or email their Support Team at support@datadoghq.com. Refer to https://www.datadoghq.com/support/ for more information.
