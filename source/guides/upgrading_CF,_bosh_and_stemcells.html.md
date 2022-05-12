---
title: Upgrading CF, BOSH and stemcells
---

# Upgrading CF, BOSH and stemcells

## Before Upgrading
* Check your environment isn't resource starved, because this can cause unexpected test failures. Typically, resource starvation in dev happens when there are a number of organisations left over from smoke and acceptance tests. These are prefixed with `SMOKE-` and `CATS-` respectively. Provided tests aren't running at the time, they can be safely deleted with `cf delete-org`.
* Separate the upgrade of Cloud Foundry and stemcells from the upgrade of Bosh. Upgrades can cause problems and our experience is that it is difficult to be certain about the cause of those problems if multiple things have changed.
* Establish the correct version to upgrade to:
  * Check [cf-deployment releases documentation](https://github.com/cloudfoundry/cf-deployment/releases).
  * Prefer the latest stable release if the release notes look like they won't introduce bugs.
  * Discuss the planned upgrade version in kick-off.

* If you encounter issues in the releases of `cf-deployment` consider forking and patching them or overriding the release version with a opsfile.

* Update the submodule in `/manifests/cf-deployment` for [paas-cf](https://github.com/alphagov/paas-cf/tree/master/manifests/cf-deployment) of cf-deployment to the picked version.

* Use `git diff` or GitHub compare in the `cf-deployment` submodule repo to see and review changes to the manifest. For example, to see differences between v1.0.0 and v1.14.0:

  ```
  git diff v1.0.0...v1.14.0 cf-deployment.yml
  ```

We also use a number of upstream ops files, so you will want to `diff` them too. See [the manifest generation script](https://github.com/alphagov/paas-cf/blob/master/manifests/cf-manifest/scripts/generate-manifest.sh) for which ones get used.

Special differences to take into account:

  * New secrets and certificates in `variables: `. Maybe there are new passwords that must be rotated or blacklisted from rotation.
  * Release version changes.
  * New `instance_groups` added

* Read the documentation for every version of every release changed. It will save you time and pain in the long run.
* Run the unit tests for the manifest with the new version of cf-deployment with `make test` or `(cd manifests/cf-manifest && bundle exec rspec --fail-fast)`. Fix issues as you find them.

* Update the cf-smoke-tests-release resource in the pipeline to pin the version used in cf-deployment.
* Update the cf-acceptance-tests resource in the pipeline to use an upstream `cfX.Y` branch matching the cf-deployment version.
* Note: If we are using a forked version of the smoke-tests or cf-acceptance test, create a new branch and rebase our forked version accordingly.

### Credhub

_(section added October 2018)_

Our upgrade to cf-deployment v4.5.0 caused us to diverge from upstream, as
documented in this [story
comment](https://www.pivotaltracker.com/story/show/160506139/comments/195512325),
by not including their suggested `credhub` instance group.

This divergence isn't set in stone, but until a _CF_-level credhub is
introduced, you should take care to check that no BOSH releases are relying on
a _CF_-level credhub instance or service. It's possible that a stronger
dependency on credhub will be introduced in the future, in which case we'll
need to do the work to re-align with upstream before upgrading. It's worth
checking for this early in the upgrade story, so that any requisite work can be
flagged as a blocker ASAP.

NBNB Here, we're talking about a _CF_-level credhub - **not** a _BOSH_-level
credhub. We anticipate that we'll have one at the BOSH layer, to replace
vars-store files, Sometime Soon
([spike](https://www.pivotaltracker.com/story/show/158978139)). Be clear about
the different consumers of any credhubs in our environments, and which one is
being excluded at the time of writing.

## Doing the upgrade

You should test the upgrade changeset:

* From a fully deployed master with `SLIM_DEV_DEPLOYMENT=false` set, which is equivalent to the change that will happen
  in production.
* Deploying a fresh CF, which is something we frequently do in our
  development environments after the autodelete-cloudfoundry pipeline
  runs overnight.
* Confirm that [rotating credentials](/team/rotating_credentials/) still
  works and doesn't cause additional downtime during deployments.


### Buildpacks

Buildpack upgrades are done separately from platform upgrades because they can impact directly on tenant apps. They are also done on a regular cadence.  

If you are doing a platform upgrade, you should upgrade the buildpacks to at least the versions included in the cf-deployment version being deployed.

We give at least a week's notice to tenants about buildpack upgrades. If the new version of any buildpack will remove an important version of a language, 
such as a long term support version, we should give a minimum of two weeks notice.

There is a (semi-)automated process for upgrading buildpacks, which includes generating the email.

The developer does the following:

* In paas-cf run `make buildpack-upgrade` to update our cache of buildpack dependencies, and generate the tenant comms copy.
* Commit the changes to a branch
* Release changes to a dev environment and check it seems ok
* Raise a PR for the changes and move the story into review
* Add the email copy to the story in Pivotal

The reviewer does the following:

* Review the email copy
* Mark the story as blocked with a blocker in the form `until 2019/09/11`
* Wait until the given date, then merge the PR to upgrade the buildpacks

Either the developer or the reviewer will send out the tenant comms copy via the [google group interface] and our Slack support channels. Emails
should have the subject "GOV.UK PaaS - Upcoming buildpack upgrades - $DATE", where $DATE is in the format "11th September 2019"


## Notify the tenants

Send an email to users following [the upgrade template](/team/notifying_tenants/#cf-upgrade).

## Problems encountered previously

### DNS name resolution.
We encountered a wide variety of acceptance and smoke test failures which were intermittent. This was due to DNS health check failures. Consul uses these health checks to validate the consistency of the DNS records it serves, and will expire DNS records where the health check has failed.

The root cause was failure to remove the `consul.agent.services` property for Diego components in the CloudFoundry manifest. [Diego release notes for version 1452](https://github.com/cloudfoundry-incubator/diego-release/releases/tag/v0.1452.0) did state these had to be removed, as Diego components now use the Locket library to configure its DNS health checks.

The solution is to read the documentation on every release you are passing, for every component you are upgrading. This is a lot of documentation, but worth it in the long run.

### CF CLI

The upgrade to cf-release v233 led to acceptance test failure, as it requires CF CLI version 6.16+. We upgraded to this version in our cf-cli and cf-acceptance-tests Docker containers, which confounded the tests of other developers when merged. Upgrades to CF CLI versions can be tested using your own private containers while in development. Perhaps we should think about versioning our docker images so that we can pin particular versions in the pipeline to match the CF & BOSH versions being deployed.

### Acceptance Test Failures

The upgrade to v233 has introduced some new tests in the acceptance-test suite, which do not appear to be quite ready for the prime-time yet.

We experienced failures in:

* `routing` suite - The `multiple_app_ports` test fails if  `users_can_select_backend` is not set to `true` - The test receives a response of `CF-BackendSelectionNotAuthorized` which does not match the expected response of `CF-MultipleAppPortsMappedDiegoToDea` and causes the test to fail - This test should not be run unless the user is permitted to switch backends. We raised an issue with Pivotal for this test :
  * [Pivotal Tracker issue #117685687](https://www.pivotaltracker.com/story/show/117685687)
  * [GitHub cloudfoundry/cf-acceptance-tests#104](https://github.com/cloudfoundry/cf-acceptance-tests/issues/104)

* `v3` suite - The `task_test` is being run even though we have the `cf-feature-flag` for `task_creation` set to `false` - The suite attempts to create a task and receives a response saying `Feature Disabled: task_creation` which does not cause any kind of failure - it then goes on to attempt to delete the task which fails as it receives and empty response to it's delete attempt, when it is expecting to receive a response indicating that the task is in a `FAILED` state
