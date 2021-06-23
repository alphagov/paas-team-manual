---
title: Rotating Credentials
---

# Rotating Credentials

## Third-party services

We store credentials for third-party services in [`pass`](https://www.passwordstore.org/) stores which have some documentation about rotating the secrets held in them:

- https://github.com/alphagov/paas-credentials/blob/master/SECRET_ROTATION.md
- https://github.com/alphagov/paas-credentials-high/blob/master/SECRET_ROTATION.md

## Platform

From time to time, it might be necessary to rotate our platform credentials. We
have created helper tasks in the deployer and bootstrap pipelines to regenerate
passwords that we know are safe to be rotated. This can be found under the
`credentials` tab of each Concourse pipeline.

### Rotating platform credentials

We have Concourse jobs for rotating credentials that can be rotated without
downtime. These might not include everything. If you are responding to a
security incident then it is worth checking whether the credentials you
care about are included.

Credential rotation is done in two phases:

1. rotation in the secret store (Credhub)
2. deployment of the secrets

These jobs are not run very often. It is wise to re-examine them for drift. Perform a test run in a development environment before executing them in a production environment.

If something goes wrong then in many cases
you can obtain the old passwords from the credential history in Credhub using
the `--versions` flag of `credhub get`:

```
$ credhub get -n /prod-lon/prod-lon/cf_admin_password --versions=10

- id: 764582ca-b3f0-4d08-8da4-6a48b69907fd
  name: /prod-lon/prod-lon/cf_admin_password
  type: password
  value: [redacted newest password]
  version_created_at: "2020-03-13T11:22:50Z"
- id: 949f97e8-5ba3-4e64-8bf2-49dc3b94ec7a
  name: /prod-lon/prod-lon/cf_admin_password
  type: password
  value: [redacted previous password]
  version_created_at: "2020-03-11T10:10:13Z"
```

#### Rotating BOSH credentials and certificates

In the `create-bosh-concourse` pipeline there are two rotation jobs under the `credentials`
tab: `rotate-bosh-credentials`  and `rotate-bosh-leaf-certs`.

To perform the rotation:

1. Pause the `create-bosh-concourse` pipeline, and ensure it isn't running
1. Run the `check-certificates` job to see if any certificates need rotation. It will fail if any certificates have expired.
1. Run the relevant rotation Concourse job (`rotate-bosh-credentials` and/or `rotate-bosh-leaf-certs`)
1. Unpause the `create-bosh-concourse` pipeline
1. Trigger the `create-bosh-concourse` pipeline and allow it to run all the way through

If the BOSH TLS certificates have expired, pipeline self-updating will need to be disabled before running the `create-bosh-concourse` pipeline, and enabled afterwards:

1. In `paas-bootstrap`
1. Run `make ENV pipelines BRANCH=main SELF_UPDATE_PIPELINE=false`
1. Trigger the pipeline
1. Run `make ENV pipelines BRANCH=main SELF_UPDATE_PIPELINE=true`

#### Rotating Cloud Foundry and Prometheus credentials

In `create-cloudfoundry` there are four rotation jobs under the `credentials`
tab:

* `rotate-cloudfoundry-credentials`
* `rotate-cf-admin-password`
* `rotate-prometheus-credentials`
* `rotate-database-encryption-keys`

To perform the rotation:
1. Pause the `create-cloudfoundry` pipeline and ensure it isn't running
1. Run one or more of the above rotation jobs as necessary
1. Unpause the `create-cloudfoundry` pipeline
1. Trugger the `create-cloudfoundry` pipeline and allow it to run to completion

### Rotating broker credentials

Our service brokers have basic auth in front of them to ensure that only we
can communicate with them. Unfortunately our brokers do not support swapping
credentials without downtime.

In the `create-cloudfoundry` pipeline, under the `credentials` tab, there
is a `rotate-broker-credentials` job. Rotating the broker credentials is a
two step process:

1. Run the `rotate-broker-credentials` job to update the credentials in Credhub.
2. Run the main `create-cloudfoundry` job to apply the new credentials.

There will be downtime between when the pipeline redeploys the brokers and
when it updates the broker credentials to be used by Cloud Controller. For
information on what happened the first time, and how to communicate this to
tenants, see https://status.cloud.service.gov.uk/incidents/3qll54zh55zk.

At the time of writing this only rotates the basic auth used to talk to the
brokers. It does not rotate other difficult secrets, such as those used to
generate passwords for service instances.

### Rotating CA and leaf certificates

We rotate CA and leaf certificates automatically as part of the `create-cloudfoundry`
Concourse pipeline. You can learn more about it by reading [ADR037 automated certificate rotation](/architecture_decision_records/ADR037-automated-certificate-rotation/)

### Rotating SSO IDP keys

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
