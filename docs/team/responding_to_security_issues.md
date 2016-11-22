# Responding to security issues

Periodically we will learn of a security issue affecting CloudFoundry or our supporting systems we use, this is the process we follow in order to triage and mitigate the problem.

## How we learn of issues

* Automated datadog CVE notifications from our [Pivotal CVE notifier](https://github.com/alphagov/paas-cve-notifier)
* Notifications from [cf-dev](https://lists.cloudfoundry.org/archives/list/cf-dev@lists.cloudfoundry.org/)
* Notifications in slack from a team member, the #security channel, or others

## How we deal with issues

1. The person on support should immediately create a Pivotal story with all the currently known information
2. The person on support should post a link to the story in #paas-incident and notify the main #the-government-paas channel that a security incident is in progress
3. The person on support should either immediately triage the issue themselves, or request support from team members with appropriate domain knowledge (See: "How to triage an issue" below)
4. If the triage outcome is that we must take action the story should be prioritised according to severity by the product manager and played if necessary
5. All PR's related to the security issue are prioritised for review until the issue is fully resolved

## How to triage an issue

1. If possible locate the original CVE report
2. Identify each component of CF and our supporting systems that is affected by the issue
3. Confirm we are vulnerable by reproducing the security issue on a suitable environment
4. Identify if there are practical ways for us to mitigate the situation, such as disabling features or altering configurations
5. Identify if the issue is fixed in a newer release of the software we are using
6. Briefly investigate how difficult the upgrade would be, if needed
7. Record all this information on the story associated with the issue
