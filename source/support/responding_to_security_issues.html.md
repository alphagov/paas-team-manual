# Responding to security issues

Periodically we will learn of a security issue affecting CloudFoundry or our supporting systems we use, this is the process we follow in order to triage and mitigate the problem.

## If you suspect a security breach

If a breach is suspected to have occurred, [alert Information Assurance (IA) immediately](https://sites.google.com/a/digital.cabinet-office.gov.uk/gds/working-at-the-white-chapel-building/security/security-incidents) to the issue and provide all required information. IA will undertake all communication with Cabinet Office's Senior Information Risk Owner (SIRO) and any external parties as required.


## How we learn of issues

* Automated CVE notifications from the [CloudFoundry security RSS feed](https://www.cloudfoundry.org/category/security/). This is implemented with [IFTTT](https://ifttt.com) - credentials are in `paas-pass`
* Notifications from [cf-dev](https://lists.cloudfoundry.org/archives/list/cf-dev@lists.cloudfoundry.org/)
* Notifications in slack from a team member, the #security channel, or others

## How we deal with issues

1. The person on support should immediately create a Pivotal story with all the currently known information
1. If a Zendesk ticket was raised, add the story link to the ticket and close the ticket
1. The person on support should notify the #paas channel that they are triaging the incident
1. The person on support should either immediately triage the issue themselves, or request support from team members with appropriate domain knowledge (See: "How to triage an issue" below)
1. If the triage outcome is that we must take action the story should be prioritised according to severity by the product manager and played if necessary
1. If the triage outcome is that we do not need to take any action, the story should be updated with the reasons why and finished as a 0 point story
1. All PR's related to the security issue are prioritised for review until the issue is fully resolved

## How to triage an issue

### Stemcell upgrades

If the mitigation to the security issue is to upgrade the stemcell, you should
apply the upgraded stemcell to a dev environment as a first step. While you are
waiting for the upgraded stemcell to be applied, the issue can be triaged. If
the upgrade applies successfully, a PR can be raised to upgrade the stemcell. If
it does not apply successfully, we should prioritise the upgrade based on the
severity of the CVE

### Other issues

1. If possible locate the original CVE report
1. Identify each component of CF and our supporting systems that is affected by the issue
1. Confirm we are vulnerable by reproducing the security issue on a suitable environment
1. Identify what the CVE report says needs to be done to mitigate the issue
1. Identify if there are any other practical ways for us to mitigate the situation, such as disabling features or altering configurations
1. Identify if the issue is fixed in a newer release of the software we are using
1. Briefly investigate how difficult the upgrade would be, if needed
1. Record all this information on the story associated with the issue
