# Rotating Credentials

## Third-party services

We store credentials for third-party services in [`pass`](https://www.passwordstore.org/) stores which have some documentation about rotating the secrets held in them:

- https://github.com/alphagov/paas-credentials/blob/master/SECRET_ROTATION.md
- https://github.com/alphagov/paas-credentials-high/blob/master/SECRET_ROTATION.md

## Platform

From time to time, it might be necessary to rotate our platform credentials. We have created helper tasks in the deployer and bootstrap pipelines, credentials tab, to clean passwords that we know are safe to re-set.

### Rotating passwords

Rotating passwords consists of two phases. First, you delete credentials using
one of the CI helper jobs.

There are two for CF (in the deployer pipeline), one for BOSH and one for
Concourse (in the bootstrap pipeline). These tasks exclude passwords that are
difficult or not safe to rotate and clean all other passwords. We do also
delete generated ssh keys in these tasks.

There are two CF cred rotation jobs (`rotate-cf-admin-password` and
`rotate-cloudfoundry-credentials`, under
`/teams/main/pipelines/create-cloudfoundry?groups=credentials`) so that you
have the choice of rotating the admin password or not. Rotating the admin
password automatically leads to the rest of the credentials being rotated, but
not vice versa.

Second phase consists of running the main pipeline (on deployer for CF, on bootstrap for BOSH and Concourse) to generate new credentials and apply them. Ensure that there is nothing else triggering this 2nd phase run, as that would mean you would be rotating passwords _and_ trying to apply some changes at the same time, which might not work and you could end up with broken deployment. Pipeline run should complete successfully and all tests should pass. There should be no interruptions to deployed apps.

### Rotating certificates

Rotating the internal certificates has 2 phases similar to rotating passwords. First we delete the existing certs, and then we run a deploy to generate and use new certificates.

1. Run `rotate-cf-certs-leafs` to delete existing non-CA certs
1. Run `create-cloudfoundry` to generate new certs and deploy them

#### Rotating CA certificates

Rotating the CA certificates that Cloud Foundry is using internally for mutual TLS
between components is a much longer process. You need to:

1. Run `rotate-cf-certs-leafs` to delete existing non-CA certs
1. Run `create-cloudfoundry` to generate new certs and deploy them
1. Run `rotate-cf-certs-cas` to copy existing CAs into `_old` suffixes
1. Run `create-cloudfoundry` to generate new CAs and deploy them alongside the old CAs
1. Run `rotate-cf-certs-leafs` to delete existing non-CA certs
1. Run `create-cloudfoundry` to generate new non-CA certs against the new CAs and deploy them
1. Run `delete-old-cf-certs` to delete old CAs
1. Run `create-cloudfoundry` to remove the old CAs

### AWS keys generated in the pipeline

The deployer Concourse has a job for triggering the rotation of AWS keys generated in the pipeline. These keys currently include:

* Those used for generating SES SMTP credentials used by UAA for sending account management emails.
* Those used by the metrics tool to check the validity of CloudFront certificates.

The job works by removing the resources from the Terraform state file (without touching the keys themselves). This causes new access keys to be generated on the next pipeline run. Unused keys are deleted in a post-deploy job after every pipeline run. This operation is safe to do at any time, so it triggers automatically every 30 days. It is also included as a step in the manual credential rotation job.

### Limited functionality during rotation

We have lot of functionality that requires credentials outside of the pipeline. These are mainly our scripts that are orchestrated via Makefile. Most of the tasks (like `bosh-cli` or any ssh tasks) will not work during rotation, as they need credentials (concourse password, ssh keys) that have been deleted and are either not available or not applied yet.

In case you need to run any of these tasks in the middle of the rotation, but before the new credentials have been applied, we suggest that you pause the pipeline first. You can download previous versions of the keys and secret files to recover needed credentials and either use them locally, or re-upload these files as latest version to the bucket. Note that if your pipeline will get into credential applying stage after you unpause, it will apply the latest uploaded credentials. If these are previous version, this means no actual credential rotation will happen and pipeline should finish without needing to apply any changes. If you still want to rotate credentials afterwards, repeat the rotation procedure again.
