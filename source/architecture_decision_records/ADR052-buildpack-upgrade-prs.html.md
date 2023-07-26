---
title: ADR052 - Automated buildpack upgrade pull requests
---

# ADR052 Automated buildpack upgrade pull requests

## Context

We maintain the default versions of the different CloudFoundry buildpacks in use on GOV.UK PaaS in
[a configuration file in `paas-cf`](https://github.com/alphagov/paas-cf/blob/main/config/buildpacks.yml).
Its content is machine-generated, and not intended for human consumption. It is used in the
[`create-cloudfoundry` pipeline](https://github.com/alphagov/paas-cf/blob/main/concourse/pipelines/create-cloudfoundry.yml#)
to configure the available buildpacks and their versions within CloudFoundry. The version of a buildpack set here will
be the version a tenant receives when they don't pin the applications to a specific version.

There are a number of steps involved in updating buildpacks, beyond the purely technical:

* remembering to perform the upgrade
* running the upgrade script
* testing the configuration changes
* raising a PR with the changes
* generating release notes and announcement copy to to go tenants
* scheduling the release of the new versions
* sending the announcement

## Problem

We review the versions of buildpacks in use each month, and look to upgrade them if newer versions have been released.
A long time ago, we realised that buildpacks had a very regular release cadence, so we scripted the process of updating the
configuration file.

However, we did not fully automate the process; we continued to require an operator to remember to run the script once
a month. This was unreliable, and we routinely missed our goal of updating buildpacks once a month at roughly the same time
each month.

## Solution

Of the number of steps needed to perform a full buildpack upgrade, only three can be performed by a computer:

1. remember to perform the upgrade
2. run the upgrade script
3. raise a PR with the changes

In short, this ADR proposes to automate running the upgrade script on the first of each month, and raising a pull
request with the changes. It is not expected that the full buildpack release process is autoamted, and we are happy
that a human will necessarily need to be involved in the majority of steps. This solutions aims to reduce the amount of
effort that an operator will have to expend to get started with, and conclude, upgrading buildpacks.

The solution being proposed has three pieces:

1. An unprivileged, regular GitHub user account which will be operated as a bot
1. A fork of `paas-cf` owned by the bot
1. A GitHub Actions workflow with a cron trigger

The GitHub Actions workflow will be triggered around the start of the work day on the first day of each calendar month,
whereupon it will run the buildpack upgrade script and commit the result to a branch in the bot user's `paas-cf` fork.
Acting as the bot user, it will then raise a pull request from its fork to `paas-cf`, which can be picked up by an
operator.

We have elected to use an unprivileged user to side-step the issues presented by a GitHub Actions workflow with
permission to make commits to the repository in which it's running. By using an unprivileged user, we benefit from all
of the regular protections offered by GitHub with little-to-no effort on our part.

Access to the unprivileged user account will be granted through an email group to which all operators are added. We will
discard the password for the GitHub account on each access, and rely on the password reset mechanism sending an email
to the group for authentication.

# Status
Accepted