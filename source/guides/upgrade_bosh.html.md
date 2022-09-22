---
title: How to upgrade BOSH
---

# Upgrading BOSH

You can find new releases of BOSH in [the BOSH repository](https://github.com/cloudfoundry/bosh/releases). Once you have decided on which version to use, carry out the following steps:

1. In [cloudfoundry/bosh-deployment](https://github.com/cloudfoundry/bosh-deployment), identify the commit that uses the version of BOSH you want to upgrade to. You can do this by checking the releases in the `bosh.yml`. For example, the following [snippet from bosh.yml](https://github.com/cloudfoundry/bosh-deployment/blob/959ed4a6a9b2739be14dd37b1ff45626892215af/bosh.yml#L150-L153) uses version `273.1.0` of BOSH:

    ```
- name: bosh
  sha1: f9f7d13df4384c0562e1fd31431053d705326f64
  url: https://s3.amazonaws.com/bosh-compiled-release-tarballs/bosh-273.1.0-ubuntu-jammy-1.8-20220822-191956-046681798-20220822191957.tgz
  version: 273.1.0
    ```
The corresponding commit is `959ed4a6a9b2739be14dd37b1ff45626892215af`.

1. Update the submodule `upstream` in [alphagov/paas-bootstrap/manifests/bosh-manifest](https://github.com/alphagov/paas-bootstrap/tree/main/manifests/bosh-manifest) to point to the commit identified in the previous step.

1. Determine if you need to make any other changes to [ops files](https://bosh.io/docs/cli-ops-files/), based on the release changes.

## Testing the upgrade

You should test the changes in a development environment by doing the following:

1. Claim one of the team development environments (`dev01`, `dev02` or `dev03`) by sending a message to the [#paas-internal channel](https://gds.slack.com/archives/CAEHMHGJ2) on GDS Slack, tagging @paas-devs.

1. Make sure the current branch of `paas-bootstrap` deployed by the `create-bosh-concourse` pipeline to the environment is `main` and has been run with the latest commit. If not, do it yourself:

    ```
gds aws paas-dev-admin -- make dev01 deployer-concourse pipelines BRANCH=main
    ```

1. Pause the `create-cloudfoundry` pipeline in the dev environment.

1. Update the `create-bosh-concourse` pipeline to deploy your `paas-bootstrap` branch to the dev environment. You can update it by running:

    ```
gds aws paas-dev-admin -- make dev01 deployer-concourse pipelines BRANCH=UPGRADE_BRANCH_NAME
    ```
where `UPGRADE_BRANCH_NAME` is the name of the branch you created for the upgrade.

1. When the `paas-bootstrap` pipeline finishes, run the `create-cloudfoundry` pipeline. Make sure you use the `main` branch of `paas-cf`.

## Checking credential rotation

Carry out the following steps to make sure our process for rotating credentials continues to work:

1. Run the `test-certificate-rotation` Concourse pipeline.
1. [Rotate the BOSH credentials and certificates](/team/rotating_credentials/#rotating-bosh-credentials-and-certificates).
1. [Rotate the broker credentials](/team/rotating_credentials/#rotating-broker-credentials).

## Merging the upgrade

If the previous steps succeed, you can open a PR for review. Once it has been approved, do the following:

1. Tell people you will be upgrading BOSH and pausing the `create-cloudfoundry` pipelines by sending a message to the [#paas-internal channel](https://gds.slack.com/archives/CAEHMHGJ2) on GDS Slack, tagging @paas-devs.

1. Make sure nothing is being deployed and pause the `create-cloudfoundry` pipeline in `staging`, `prod` and `prod-lon`. You can do this by pausing the `pipeline-lock` job for each environment in Concourse.

1. Merge-sign the PR. The gds-cli has a useful utility for this:

    ```
gds git merge-sign alphagov/paas-cf <PR_NUMBER>
    ```
1. Trigger the `create-bosh-concourse` pipeline in `staging`. You can do this by triggering a new build of the `init-bucket` job in Concourse. When it finishes, do the same for the `prod` and `prod-lon` pipelines.

1. Unpause all the `create-cloudfoundry` pipelines.
