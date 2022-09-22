---
title: How to upgrade the cf-deployment
---

# Upgrading cf-deployment

## Before upgrading

1. Before upgrading cf-deployment, you should check your environment is not resource starved because this can cause unexpected test failures. Typically, resource starvation in dev happens when some organisations are left over from smoke and acceptance tests. These organisation names are prefixed with SMOKE- and CATS- respectively. If tests are not running at the time, you can safely delete the organisations with the script `paas-cf/scripts/cleanup_leftover_test_orgs.sh`.
1. Avoid upgrading of cf-deployment at the same time as upgrading stemcells and/or the Bosh director. Upgrades can cause problems and our experience is that it is difficult to be certain about the cause of those problems if multiple things have changed.
1. Find out the correct version to upgrade to by checking the [cf-deployment releases documentation](https://github.com/cloudfoundry/cf-deployment/releases). Choose a recent stable release, but try to avoid releases less than a couple of weeks old. Discuss the planned upgrade version in kick-off.
1. Read the documentation for every version of every release in the [changelog](https://github.com/cloudfoundry/cf-deployment/releases) since the last update. It will save you time and pain in the long run.

## Preparing the upgrade
1. If you have issues in the releases of cf-deployment, consider overriding the release version with an [ops file](https://bosh.io/docs/cli-ops-files/). For example, when [updating cf-deployment to version 20.2.0](https://github.com/alphagov/paas-cf/pull/2902) we needed an ops file to disable a feature (dynamic ASGs) that was enabled by default by the upstream.
1. Update the submodule cf-deployment in [manifests for paas-cf](https://github.com/alphagov/paas-cf/tree/main/manifests) to the version you chose.
1. To see and review changes to the manifest, use the `git diff` command or the GitHub Compare UI in the cf-deployment submodule repo. For example, to see differences between v21.0.0 and v21.05.0, run `git diff v21.0.0...v21.05.0 cf-deployment.yml`.
1. We also use a number of upstream ops files, so you will want to diff them too. You can find them included in the config as symlinks in `manifests/cf-manifest/operationds.d` with the suffix `-UPSTREAM`.
Special differences to take into account are:
  - new secrets and certificates in variables - maybe there are new passwords that must be rotated or blacklisted from rotation
  - release version changes
  - new `instance_groups` added
1. Run the unit tests for the manifest with the new version of cf-deployment with `make test` or `cd manifests/cf-manifest && bundle exec rspec --fail-fast`. Fix issues as you find them. If you're having trouble getting make test to run locally, you can see it run in GitHub Actions when you raise a PR.
1. Update the `cf-smoke-tests-release` resource in the pipeline to pin the version used in cf-deployment.
1. Update the cf-acceptance-tests resource in the pipeline to use an upstream `cfX.Y` branch matching the cf-deployment version. If we are using a forked version of the smoke-tests or cf-acceptance test, create a new branch and rebase our forked version.

## Testing the upgrade
You should test the upgrade changeset by doing the following:

1. Claim one of the team development environments (dev01, dev02 or dev03) by sending a message to the [#paas-internal channel](https://gds.slack.com/archives/CAEHMHGJ2) on GDS Slack, tagging @paas-devs.
1. Make sure the current branch of paas-cf deployed to the environment is `main`.
1. Update and run the pipeline with `SLIM_DEV_DEPLOYMENT=false`, which is equivalent to the change that will happen in production. For example for `dev01` issue:

    ```
  gds aws paas-dev-admin -- make dev01 pipelines BRANCH=main SLIM_DEV_DEPLOYMENT=false
    ```
1. Run the pipeline with the updated cf-deployment branch and make sure all acceptance tests have passed. This is important because the development environment might previously have been used to test things such as partial updates.

     ```
  gds aws paas-dev-admin -- make dev01 pipelines BRANCH=UPGRADE_BRANCH_NAME SLIM_DEV_DEPLOYMENT=false
     ```
     where `UPGRADE_BRANCH_NAME` is the name of the branch you created for the upgrade.
1. Confirm that the process for [rotating credentials](https://team-manual.cloud.service.gov.uk/team/rotating_credentials/) still works.



## Merging the upgrade

If all the above tests pass, merge-sign the PR. The gds-cli has a useful utility for this:

```
gds git merge-sign alphagov/paas-cf <PR_NUMBER>
```

This will trigger our continuous deployment pipelines and move the change through staging into the production environments.
