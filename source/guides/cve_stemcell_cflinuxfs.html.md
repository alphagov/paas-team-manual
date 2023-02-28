---
title: Responding to CVEs, upgrading stemcells and cflinuxfs
---

# Responding to CVEs, upgrading stemcells and cflinuxfs

The team must be prepared to triage and address common vulnerabilities and exposures (CVEs).
Most CVEs also require upgrading the [stemcells](https://bosh.io/docs/stemcell/) and [cflinuxfs](https://github.com/cloudfoundry/cflinuxfs3).

## How we learn about CVEs

We learn about CVEs through:

- automated CVE notifications through [Zendesk](https://govuk.zendesk.com/auth/v2/login/signin?return_to=https%3A%2F%2Fgovuk.zendesk.com%2Fagent%2Ffilters%2F360001049225&theme=hc&locale=1176&brand_id=3194076&auth_origin=3194076%2Cfalse%2Ctrue&role=agent) from the [CloudFoundry security RSS feed](https://www.cloudfoundry.org/foundryblog/security-advisory/) – the feed is converted to Zendesk tickets using [IFTTT](https://ifttt.com/)
- notifications from [cf-dev mailing list](https://lists.cloudfoundry.org/g/cf-dev) from CloudFoundry
- notifications in Slack (for example, the [Cloud Foundry Slack channel](https://cloudfoundry.slack.com/))
[Dependabot](https://github.com/alphagov/paas-admin/pulls?q=is%3Apr+author%3Aapp%2Fdependabot) (for frontend vulnerabilities)

## How to triage CVEs

To triage CVEs, you should consider:

- which libraries or tools are affected
- how severely the libraries or tools are affected
- how the vulnerability affects us or tenants
- the likelihood of the vulnerability being exploited – for example, what kind of library or program is it? Would it be public facing in some way? Is it likely to be fed user input in a tenant application? What would an attacker need to do to get into a position where they could exploit it on PaaS?

You should then record the priority decision (high, low) in the ticket.

## How to address the CVE

If the CVE is high priority, you should:

- immediately create a story in Pivotal Tracker with all known information about the CVE (if there are multiple CVEs, merge them into one Pivotal story)
- link to the original CVE report
- identify which components are affected
- identify what needs to be done to mitigate the issue (for example, upgrading to a newer version)

If the CVE is low priority or there is a low likelihood of exploitation, you should:

- put a ticket at the top of the icebox section in Pivotal Tracker and prioritise it at the next session
- check if you can address the CVE by upgrading to a newer stemcell and cflinuxfs3 or cflinuxfs4 version during the regular platform upgrade process

For both high and low priority CVEs, you should:

- use instructions from the CVE report to mitigate the issue (for example, upgrading to a newer version of the affected component) or find other practical ways to mitigate the issue (for example, disabling features or altering configurations)
- record the previous and new version of the affected component if upgrading
- decide if the comms person needs to contact tenants with information about vulnerabilities, changes or new implementations (for example, if tenants need a buildpack upgrade)
- record the result on the Pivotal story associated with the issue


## Upgrading stemcells and cflinuxfs
### Obtaining latest bionic stemcell and cflinuxfs releases
You can find the [latest version of Ubuntu stemcells (Ubuntu Jammy)](https://bosh.io/stemcells/bosh-aws-xen-hvm-ubuntu-jammy-go_agent) 
on the Cloud Foundry BOSH website, along with the [latest version of cflinuxfs3](https://bosh.io/releases/github.com/cloudfoundry/cflinuxfs3-release?all=1#latest) and [cflinuxfs4](https://bosh.io/releases/github.com/cloudfoundry/cflinuxfs4-release?all=1#latest).

### Testing and deploying
In GitHub, create a pull request in the `paas-cf` and `paas-bootstrap` repositories (see sample pull requests for [updating `paas-cf`](https://github.com/alphagov/paas-cf/pull/2946/files) and [updating `paas-bootstrap`](https://github.com/alphagov/paas-bootstrap/pull/509/files)), then deploy to a dev environment. 
If the deployment is successful, merge the pull request and deploy to both staging and production.

