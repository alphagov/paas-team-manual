---
title: ADR051 - How we plan to migrate from cflinuxfs3 to cflinuxfs4
---

# ADR0051: How we plan to migrate from cflinuxfs3 to cflinuxfs4

## Context

[`cflinuxfs3`](https://github.com/cloudfoundry/cflinuxfs3) is a configured and packaged
deployment of [Ubuntu Bionic](https://releases.ubuntu.com/18.04/) which we use as the
base layer (stack) for the containers we build from tenant source code. It is maintained 
by the CloudFoundry Foundation, who ensure that new releases of it contain fixes and
mitigations for relevant CVEs.

In April 2023, Ubuntu Bionic (18.04) will reach [the end of its standard support period](https://wiki.ubuntu.com/Releases).
and will no longer receive security updates. The CloudFoundry Foundation also will cease 
support for `cflinuxfs3` at the same time, with the same effect. Relying on it once
it is out of support presents a greater risk to us, because any subsequently discovered 
exploitable vulnerability will not be mitigated or patched.

[Ubuntu Jammy (22.04)](https://releases.ubuntu.com/22.04/) is the successor to Ubuntu Bionic, 
and `cflinuxfs4` succeeds `cflinuxfs3`.

Before April 2023, the CloudFoundry Foundation will [introduce `cflinuxfs4` to `cf-deployment`
and make it the default stack](https://github.com/cloudfoundry/cf-deployment/issues/1047), and 
after April it will [remove `cflinuxfs3` from `cf-deployment` by default](https://github.com/cloudfoundry/cf-deployment/issues/1048)
but provide an ops file to reintroduce it optionally.

### Complicating factors

Reaching the end of a support period for a piece of software is common, and upgrading to 
the next version isn't typically a big deal. However, in the case of `cflinuxfs3` to 
`cflinuxfs4` there are some complicating factors:

* Tenant applications implicitly depend on the operating system and the exact collection
  of libraries (and versions) supplied. Library major versions often change between OS
  releases (for example [Bionic has `openssl` 1.1.1](https://packages.ubuntu.com/bionic/openssl) 
  while [Jammy has `openssl` 3.0.2](https://packages.ubuntu.com/jammy/openssl)) and we
  cannot assume that changing the base layer of the container images won't break 
  applications.
  <br /><br />
  Tenants must test their applications against `cflinuxfs4` and resolve any problems for 
  themselves. We cannot provide much support in this, given the number of applications 
  on the platform and the variety of technologies in use.
  <br /><br />

* Tenants are often slow to respond to communications and calls to action. This is a 
  problem we have faced through the lifetime of the platform, and we usually build this 
  into our plans by providing a long window (for example 9 months for Postgres 10 deprecation)
  in which to act and issuing regular reminders. Unfortunately in this case we have not 
  given ourselves a long lead time, and as of 14th Feb 2023 the CloudFoundry Foundation 
  still has 3 buildpacks missing support for `cflinuxfs4`.
  <br /><br />
  Regardless, we must provide an adequate timeframe for tenants to act in.
  <br /><br />

* GOV.UK PaaS is in the middle of being decommissioned, and every tenant is being asked
  to migrate away from the platform. For many of them this is consuming a significant
  proportion of their development capacity, and in most cases they will have to work out
  how to prioritize migration activities against the work to swap to `cflinuxfs4`.
  <br /><br />
  We must set our expectations of how quickly tenants will act accordingly. 
  Some may choose not to transition to `cflinuxfs4`, in favour of trying to migrate away 
  from the platform before any `cflinuxfs3` deadline.

## Decision

Given the complicating factors, and the risks associated with running an unsupported base 
operating system version, we will do the following

1. Offer `cflinuxfs4` on GOV.UK PaaS as soon as it is available, but keep `cflinuxfs3` 
   as the default
2. Communicate the upcoming change to tenants
3. Provide monthly reminders alongside decommissioning news
4. Provide a 4-month window in which to make the change
5. Make `cflinuxfs4` the default at the end of the 4-month period
6. Offer `cflinuxfs3` until the platform is fully decommissioned to support those tenants 
   who cannot, or choose not to, make the switch. Tenants who do this will be doing so
   at their own risk, and must clear it with their own Information Assurance teams, 
   risk management processes etc.

### Risk mitigations/controls
Basing tenant applications on an unsupported OS version presents us a medium level risk, due
to the opportunity for vulnerabilities of varying severity to go un-patched, and exploitation to go
unnoticed. To account for this we will monitor [the Ubuntu Security Notices for Bionic](https://ubuntu.com/security/notices?order=newest&release=bionic&details=)
so that we have continued visibility of any vulnerabilities. The Cloud Foundry Foundation Vulnerability Management 
Working Group will also continue to publish Ubuntu Security Notices for Bionic for as long as it is supported in any 
way in [`cf-deployment`](https://github.com/cloudfoundry/cf-deployment). On notification of a CVE the team will be 
responsible for understanding its scope and severity. We will inform tenants as necessary, and  point them to mitigations 
they can put in place.

We mitigate the risk somewhat by reducing the number of instances in which a container is running
with `cflinuxfs3` as the base. We can do this by encouraging tenants to move to `cflinuxfs4`, and 
making it clear to them that if, at the end of the 4-month period, they are still using `cflinuxfs3`
then they are responsible for the risk to their own applications.

## Status

Accepted

## Consequences

As a consequence of the above decision, we will continue to base tenant applications on Ubuntu Bionic (`cflinuxfs3`), 
by default, for 4 months (April - July 2023). For 3 of those months (May - July 2023), Ubuntu Bionic will 
be an unsupported operating system version. This is an elevated risk that we accept,
and which tenants can mitigate for themselves by moving to `cflinuxfs4`.

We are also choosing to offer the unsupported operating system for the rest of the lifetime of 
the platform, but not as the default after a 4-month period. This will allow us to support tenants 
who either cannot or will not switch to `cflinuxfs4`, and allows the risk to be assumed by the 
tenant selectively. 

We think our existing application isolation and security controls are sufficient 
to protect the platform and tenants in the event of a serious, exploitable vulnerability being
discovered in Ubuntu Bionic after it leaves its standard support period.