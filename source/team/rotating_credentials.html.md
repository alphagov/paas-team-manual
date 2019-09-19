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

### Rotating CA and leaf certificates

We rotate CA and leaf certificates automatically as part of the `create-cloudfoundry`
Concourse pipeline. You can learn more about it by reading [ADR448 automated certificate rotation](/architecture_decision_records/ADR448-automated-certificate-rotation/)

#### Rotating SSO IDP keys

We use single sign-on using Google and Microsoft to allow our tenants to sign
in, without using a username and password stored in UAA.

Google has two credentials: `client_id` and `client_secret`

Microsoft functionally has three credentials `client_id`, `client_secret`, and
`tenant_id`, however `tenant_id` is not secret, we just store it as such.

UAA is not capable of consuming multiple pairs of `client_id` and `client_secret`.
Rotating these credentials will briefly prevent users from signing in to GOV.UK
PaaS using single sign-on via the IDP with credentials currently being rotated.

Rotating these credentials requires changing the values in `paas-credentials`
and running the `upload-{google,microsoft}-oauth-secrets` Make tasks and then
running `create-cloudfoundry`.

### AWS keys generated in the pipeline

The deployer Concourse has a job for triggering the rotation of AWS keys generated in the pipeline. These keys currently include:

* Those used for generating SES SMTP credentials used by UAA for sending account management emails.
* Those used by the metrics tool to check the validity of CloudFront certificates.

The job works by removing the resources from the Terraform state file (without touching the keys themselves). This causes new access keys to be generated on the next pipeline run. Unused keys are deleted in a post-deploy job after every pipeline run. This operation is safe to do at any time, so it triggers automatically every 30 days. It is also included as a step in the manual credential rotation job.

### Limited functionality during rotation

We have lot of functionality that requires credentials outside of the pipeline. These are mainly our scripts that are orchestrated via Makefile. Most of the tasks (like `bosh-cli` or any ssh tasks) will not work during rotation, as they need credentials (concourse password, ssh keys) that have been deleted and are either not available or not applied yet.

In case you need to run any of these tasks in the middle of the rotation, but before the new credentials have been applied, we suggest that you pause the pipeline first. You can download previous versions of the keys and secret files to recover needed credentials and either use them locally, or re-upload these files as latest version to the bucket. Note that if your pipeline will get into credential applying stage after you unpause, it will apply the latest uploaded credentials. If these are previous version, this means no actual credential rotation will happen and pipeline should finish without needing to apply any changes. If you still want to rotate credentials afterwards, repeat the rotation procedure again.
