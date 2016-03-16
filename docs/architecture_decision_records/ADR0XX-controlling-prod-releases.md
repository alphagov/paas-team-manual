
Context
=======

At the time of writing we have two types of environment:

- development environments: short lived environments belonging to inviduals and
  pulling changes from branches
- CI master environment: a persistent environment that applies changes as they
  are pushed to the master branch in git

We wish to add a production environment and only apply safe changes to it,
meaning that:

- the changeset has been [inspected by at least one other person before being
  merged to master by pull
request](https://gdstechnology.blog.gov.uk/2014/01/27/how-we-use-github/)
- it has been through automated testing (currently Cloud Foundry smoke and
  acceptance tests).

We previously [spiked](https://www.pivotaltracker.com/story/show/109036472) how
we might promote changes between concourse instances, decided that [git
tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) were a reasonable
solution and [amended](https://www.pivotaltracker.com/story/show/112497991) the
git resource to support [creating annotated
tags](https://github.com/concourse/git-resource/pull/32) and
[reading](https://github.com/concourse/git-resource/pull/31) from git tags.

There are advantages in having a low latency and automated path to production,
which include:
- the ability to apply urgent updates such as critical security updates quickly
- making it practical to deploy smaller, more inspectable and reversible
  changesets

There were some residual things we were worried about:

- We would like to ensure that the precise version transitions that production
  will make are tested prior to production. 
- By allowing concourse to push tags, we are also allowing its credentials to
  be used to push actual commits, since github uses one privilege to allow
  both.
- If anyone gained access to one of our personal github accounts via
  credentials or malware, it would allow them to commit, push and tag for prod,
  circumventing our review process. 

We considered the following options:

- adding an approval step at some point in the process prior to production in
  which a git tag gets signed by a human, or a list of allowed commits/tags is
  updated.
- lots of notification when production changes happen, so that if unauthorised
  changes are made we detect and can react to them.

Decision
========

We will try to reinforce the process we have, rather than adding additional
approval steps. Our intention is to add a signed tag when a pull request is
merged, confirming that it has been reviewed.

The CI, staging and production concourses will check that a tag is signed
correctly before applying it to the environment.

The production concourse will check that a tag is signed by the staging
concourse.

In order to mitigate the risks of a single laptop or credential compromise
allowing a prod deployment we have two options:

- ensure that the tag is signed by two individuals (committer and reviewer) so
  that two sets of credentials are required
- using a hardware token such as a yubikey to perform the signature and
  removing it from the device when it is not in use.

Status
======

Proposed. Will only be accepted if spike(s) complete to our satisfaction.

Consequences
============

A pull request is the last point at which human review can happen, so we must
be prepared to invest in automated testing and improvements to our ability to
review changes in our development environments.
