# Notifying tenants

Every now and then, we need to let our tenants know something has happened or will happen on the platform. For example:

* security problems and fixes
* upgrades of CF, stemcells, buildpacks
* incident reports
* ongoing incidents

## Email draft

Write a draft email using a [template](#templates) as required and share it for example in [Google Docs](https://drive.google.com/drive/folders/0Bw4pWpR0IbJfWGFEMVBBZlFsSDQ).

Then get someone else on the team to proofread it.

## Send the email

Use the [google group interface](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/?hl=en#!forum/gov-uk-paas-announce) to send the email.

* Click on `New topic`
* In `By` select: Post on behalf of GOV.UK PaaS announce
* The `Subject` should help identify immediately the purpose of the email.
Ex: "Incident with..."
* In `Type of post` select: "Make an announcement" to emphasize this is
one way communication
* Body: paste the content of the reviewed draft. You may have to adjust formatting.

## Templates

In general you can follow this basic format:

* What we are doing
* Why we are doing it
* How it affects/benefits the Tenant and their users 
* Action the user needs to take

The equivalent for incidents would be:

* What is happening (that we know)
* What we are doing
* Any action the user should take (or things we know they *shouldn't* do)


### We're having an incident email template

####   Email subject

This should start with ‘IMPORTANT:’
 
_[If possible, be specific about what the problem is or the problem that the end user might be experiencing, ie:]_ 
 
* IMPORTANT: problem accessing the GOV.UK PaaS API
* IMPORTANT: problem affecting GOV.UK PaaS applications
* IMPORTANT: GOV.UK PaaS outage
 
_[If it’s not possible to be specific or we don’t know what the cause/effect is, use:]_
 
* IMPORTANT: problem with GOV.UK PaaS

####   Email body

We are aware of and investigating a problem with GOV.UK PaaS.
 
_[Where known, explain what we know about what the issue is and how it affects Tenants and their users. For the latter, you could use:]_

* Your users can’t access your service
* Your website/service is down and unavailable to your users
* Some user requests may fail
* Your users can only access your service intermittently
* [API down] ...which means you can’t update/access your service
* You won’t be able to access your applications
* You’re not receiving any metrics for your service
* You’re receiving a high number of error messages
* You’re experience high error rates

 
_[If applicable, summarise any action Tenants should or shouldn’t take.]_
 
We’re looking into this as a matter of urgency and will update you as soon as we know more. 
 
Regards,
 
_[Name and role of person handling incident comms]_ 

GOV.UK PaaS team



### Update during an incident email template

####   Email subject

UPDATE: _[This should duplicate the content of the first incident notification email subject - unless this wasn’t specific, in which case we should amend it to say what the problem is, ie:]_

* UPDATE: problem accessing the GOV.UK PaaS API
* UPDATE: problem affecting GOV.UK production applications

####   Email body

We are actively working on the issue of _[summarise problem that was established in the first notification email.]_

We have _[explain **what we’ve done** to investigate and **what steps we’ve taken** so far to resolve the issue.]_

_[If relevant, describe any:_
 
* _action users should take_ 
* _action users shouldn’t take_
* _workarounds that would help users]_

Fixing this issue is our priority - we know that this has impacted on the service you provide and we’re doing everything we can to resolve it as quickly as possible. 
 
We’ll continue to update you as we know more, and we’ll let you know as soon as the problem has been resolved.
 
We’re sorry for the inconvenience that this has caused to your users and your team. 
 
If you need to contact us for help or anything else, please email us via gov-uk-paas-support@digital.cabinet-office.gov.uk 

Regards,

_[Name and role of person handling incident comms]_

GOV.UK PaaS team


### Further updates during an incident email template

####   Email subject

UPDATE: _[This should duplicate the content of the first update email subject]_.

####   Email body

Hello,

We are still working to resolve the issue of _[summarise problem that was established in the first notification email.]_


Since our last update, we have _[explain what we’ve done to a) investigate and b) resolve the issue since the last update email.]_
 
_[If relevant, describe any:_
 
* _new action users should take_ 
* _new action users shouldn’t take_
* _workarounds that would help users]_
 
We’ll continue to update you as we know more, and we’ll let you know as soon as the problem has been resolved.
 
Once again, we’re sorry for the inconvenience that this has caused to you and your users. 
 
If you need to contact us for help or anything else, please email us via gov-uk-paas-support@digital.cabinet-office.gov.uk

Regards,

_[Name and role of person handling incident comms]_

GOV.UK PaaS team



### We've resolved the incident email template

####   Email subject

RESOLVED: _[This should duplicate the content of the previous update email subject]_
 
####   Email body 
 
Hello,
 
We’ve resolved the issue that affected GOV.UK PaaS today, and full service has been restored to development and production applications running on the platform.
 
_[Describe what the issue was and how it affected Tenants and their users.]_
 
_[Describe the actions we took to fix the problem - there’s no need to include everything we tried or investigated, just the actions that led to us resolving the incident.]_
 
We’ll now start looking into why and how this happened. In the coming days, we’ll publish an incident report describing the timelines of the event, root cause of the problem, lessons we’ve learned and actions we’ll take to ensure it doesn’t happen again.  
 
I’m sorry for the impact that this has had on your users and the service you provide, and the problems this has caused for your team. 
 
_[If there’s an outage, add the following to the sentence above:]_
 
Making sure GOV.UK PaaS is constantly available and robust is our priority and we’ll be doing everything we can to minimise the possibility of outage in the future.
 
The quickest way to get help using the platform is to email us via gov-uk-paas-support@digital.cabinet-office.gov.uk.	To let us know how this incident has affected you, please contact the GOV.UK PaaS product managers: tom.dolan@digital.cabinet-office.gov.uk and jessica.o’leary@digital.cabinet-office.gov.uk. 

Regards,
	
_[Name and role of person handling incident comms]_

GOV.UK PaaS team

### CF upgrade

Subject (ex): GOV.UK PaaS - Cloud Foundry changes - 17th March 2017

The body should contain:

 - Changes and bugfixes to highlight and new features enabled.
 - Downtime or service impact if any
 - Summary of buildpack changes. In order to retrieve the buildpack notes, you can use the script:
`paas-cf/scripts/generate_buildpack_release_notes.sh`
