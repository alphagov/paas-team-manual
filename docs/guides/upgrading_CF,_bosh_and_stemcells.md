## Before Upgrading

* Only upgrade one thing per pull request unless you have a very good reason not to. Upgrades can cause problems and our experience is that it is difficult to be certain about the cause of those problems if multiple things have changed. 
* Establish the correct version to upgrade to. This will usually be the latest stable release minus two, subject to review of the version in question. The main driver for the current-minus-two strategy is to avoid the bad releases which CF produce from time to time. An alternative strategy may be to pick a release at least two weeks old, thereby giving Pivotal time to flag and pull and bad releases before we plough ahead with them. Kick-off is an appropriate place for this review. 
* Check [cf-release releases documentation](https://github.com/cloudfoundry/cf-release/releases) before upgrading to a particular version. There have been versions, such as [v232](https://github.com/cloudfoundry/cf-release/releases/tag/v232), where the release is not appropriate for production usage.
* Refer to cf-release documentation for recommended versions of all related releases (for example, Diego and related components). Read the documentation for every release of all of these components. It will save you time and pain in the long run.
* Check the [diego release documentation](https://github.com/cloudfoundry-incubator/diego-release/releases)
* Check the [etcd release documentation](https://github.com/cloudfoundry-incubator/etcd-release/releases)
* Check the [consul release documentation](https://github.com/cloudfoundry-incubator/consul-release/releases)
* Check the [garden linux release documentation](https://github.com/cloudfoundry-incubator/garden-linux-release/releases)
* Check the [bosh release documentation](https://github.com/cloudfoundry/bosh/releases)
* Check the [stemcell release documentation](http://bosh.cloudfoundry.org/stemcells/)
* Check the job ordering in the [Diego manifest](https://github.com/cloudfoundry/diego-release/blob/develop/manifest-generation/diego.yml) to see if our job ordering needs to change as well.
* Use `git diff` in the `cf-release` repo to see example changes to the manifest templates. For example, to see differences between v228 and v233:
```
git diff --exit-code -U5 --patience v228...v233 templates
```

## Doing the upgrade

You should test the upgrade changeset:

* From a fully deployed master, equivalent to the change that will happen in
  in production.
* Deploying a fresh CF, which is something we frequently do in our
  development environments after the autodelete-cloufoundry pipeline
  runs overnight.

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
https://www.pivotaltracker.com/story/show/117685687
https://github.com/cloudfoundry/cf-acceptance-tests/issues/104

* `v3` suite - The `task_test` is being run even though we have the `cf-feature-flag` for `task_creation` set to `false` - The suite attempts to create a task and receives a response saying `Feature Disabled: task_creation` which does not cause any kind of failure - it then goes on to attempt to delete the task which fails as it receives and empty response to it's delete attempt, when it is expecting to receive a response indicating that the task is in a `FAILED` state
