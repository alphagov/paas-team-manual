# Upgrading Concourse

This document explains how to upgrade Concourse to a newer version.

## Preparing the pull requests

You can find new releases of Concourse in the [documentation for the Cloud Foundry BOSH releases](https://bosh.io/releases/github.com/concourse/concourse-bosh-release?all=1). Find the version you want to upgrade to and carry out the following steps:

1. Update the Concourse release in the [concourse manifest](https://github.com/alphagov/paas-bootstrap/blob/main/vagrant/docker-compose.yml) with the new `version`, `url` and `sha`. For example:

    ```
version: "7.8.3"
url:"https://bosh.io/d/github.com/concourse/concourse-bosh-release?v=7.8.3"
sha1: "5d80eb00215b59b4c93f0938cb465fd28036b04d"
    ```

2. Update the version for the [vagrant image](https://github.com/alphagov/paas-bootstrap/blob/main/vagrant/docker-compose.yml). For example:

    ```
concourse-web:
    image: concourse/concourse:7.8.3
...
concourse-worker-colocated:
    image: concourse/concourse:7.8.3
...
concourse-worker-normal:
    image: concourse/concourse:7.8.3
    ```

3. Create a pull request in [`paas-bootstrap`](https://github.com/alphagov/paas-bootstrap).

### Testing the upgrade in a dev environment

1. Claim one of the dev environments by sending a message to the [#paas-internal](https://gds.slack.com/archives/CAEHMHGJ2) channel on GDS Slack, tagging @paas-devs.
2. Make sure the current branch of `paas-bootstrap` deployed by the **create-bosh-concourse** pipeline to the environment is `main` and has been run with the latest commit. If not, run the following command, where `$ENV` is the name of the environment (for example “dev01”), and where `$ACCOUNT` is the name of the AWS account targeted (for example “dev”):

    ```
gds aws paas-$ACCOUNT-admin -- make $ENV deployer-concourse pipelines BRANCH=main
    ```
After this, re-run the pipeline.

3. Pause the **create-cloudfoundry** pipeline in the dev environment so a Cloud Foundry deployment cannot happen at the same time.
4. Update the **create-bosh-concourse** pipeline to deploy your `paas-bootstrap` branch to the dev environment. You can update it by running:

    ```
gds aws paas-dev-admin -- make $ENV deployer-concourse PIPELINES branch=YOUR_BRANCH_NAME
    ```

5. The **concourse-deploy** job might fail because the BOSH Director destroys the Concourse worker. This is expected behaviour, as the destruction of the Concourse worker has no impact on BOSH’s ability to continue its work. If this happens, you will need to trigger a new build for the **concourse-deploy** job.
6. When the **create-bosh-concourse** pipeline finishes, run the **create-cloudfoundry** pipeline using the `main` branch of `paas-cf`.

### Testing the upgrade for Concourse Lite

1. Claim one of the dev environments by sending a message to the [#paas-internal](https://gds.slack.com/archives/CAEHMHGJ2) channel on GDS Slack, tagging @paas-devs..
2. Launch Concourse Lite.

    ```
gds aws paas-$ACCOUNT-admin -- make $ENV deployer-concourse bootstrap
    ```

3. [Log into Concourse Lite](http://127.0.0.1:8080/login) using the credentials shown in the output from Step 2.
4. If Step 3 is successful, shut down Concourse Lite by running the **self-terminate** pipeline.
## Merging the upgrade

If the previous steps succeed, you can open a pull request in `paas-bootstrap`. After an engineer approves the pull request, do the following:

1. Merge-sign the pull request using the following command in the [gds-cli](https://github.com/alphagov/gds-cli):

    ```
gds git merge-sign alphagov/paas-bootstrap <PR_NUMBER>
    ```

2. Check there are no active deployments, then send a message to the [#paas-internal](https://gds.slack.com/?redir=%2Farchives%2FCAEHMHGJ2) channel on GDS Slack, informing @paas-devs you will be upgrading Concourse and pausing the **create-cloudfoundry** pipelines.
3. To deploy to the dev environments, make sure nothing is being deployed and pause the **pipeline-lock** job in the **create-cloudfoundry** pipeline.
4. Trigger the **create-bosh-concourse** pipeline in the dev environments. You can do this by triggering a new build of the **init-bucket** job in Concourse.
5. To deploy to `ci`, make sure nothing is in active deployment and trigger the **create-bosh-concourse** pipeline. You can do this by triggering a new build of the **init-bucket** job in Concourse.
6. To deploy to `staging`, make sure nothing is being deployed and pause the **pipeline-lock** job in the **create-cloudfoundry** pipeline.
7. Trigger the **create-bosh-concourse** pipeline in `staging`. You can do this by triggering a new build of the **init-bucket** job in Concourse.
8. Once this is finished, unpause the **create-cloudfoundry** pipeline by pausing the **pipeline-lock** job in `staging`.
9. Before deploying to production, notify the [#cyber-security-help](https://gds.slack.com/?redir=%2Farchives%2FCCMPJKFDK) channel, informing them that you are pausing the **create-cloudfoundry** pipelines in both `prod` and `prod-lon`, which means they won’t see any logs for 1-2 hours and they may receive an alert.
10. Follow steps 5 to 7 for `prod` and `prod-lon` to pause and trigger the pipelines.
11. Once this is finished, unpause the pipelines and notify the [#cyber-security-help](https://gds.slack.com/?redir=%2Farchives%2FCCMPJKFDK) channel, informing them that you have unpaused the pipelines, so they should start receiving logs again.