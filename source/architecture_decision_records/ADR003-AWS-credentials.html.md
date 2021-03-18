---
title: ADR003 - AWS credentials
---

# ADR003: AWS credentials

## Context

Amazon Web Services (AWS) are our current Infrastructure as a Service (IaaS)
provider. Our deployment tooling (Concourse, Terraform, BOSH, etc.) and
Cloud Foundry components (Cloud Controller, RDS broker, blobstore clients,
etc.) use the APIs to manage or access IaaS resources.

The most common mechanism for authenticating the API calls is to create an
Identify and Access Management (IAM) user with the appropriate permissions,
generate an Access Key ID and Secret Access Key for that user, and export
those as environment variables. `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` are the standard environment variable names used by
most utilities and libraries.

The problem with this approach is that it's very easy to accidentally leak
the plain text keys. They can appear in output from your shell, which you
might copy+paste into a gist or email when debugging a problem. You might
add them to your shell configuration or include them in a script, which can
be pushed to a public code repository.

Our team have leaked keys like this on more than one occasion. It's worth
noting that even if you realise that you've done this, delete the commit and
revoke the keys, they may have already been used maliciously because
automated bots monitor sites like GitHub using the [events firehose][] to
detect any credentials.

[events firehose]: https://developer.github.com/v3/activity/events/

As an alternative to using pre-generated keys, AWS recommends that you use
[IAM roles and instance profiles][] when accessing the API from EC2
instances. You delegate permissions to the EC2 instance and temporary
credentials are made available from the instance metadata service. Most
tools and libraries automatically support this. The credentials are
regularly rotated and never need to be stored in configuration files.

[IAM roles and instance profiles]: http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#use-roles-with-ec2

## Decision

To reduce the likelihood of us leaking AWS keys we will use IAM roles and
instance profiles for all operations that run from EC2 instances. This
includes everything that happens within Concourse and Cloud Foundry.

To reduce the impact of us leaking AWS keys we will use an IAM policy with
an [`aws:SourceIp` condition][condition] to
enforce that IAM accounts for team members are only used from the office IP
addresses.

[condition]: http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html#iam-policy-example-deny-source-ip-address

The IAM roles, profiles, and policies will be managed by our
[aws-account-wide-terraform][] repo.

[aws-account-wide-terraform]: https://github.digital.cabinet-office.gov.uk/government-paas/aws-account-wide-terraform

## Status

Accepted

## Consequences

We'll still need to use AWS keys for operations that run outside of EC2.
Care must be taken when storing and handling these credentials. These
operations include:

- Creation of Bootstrap Concourse instance
- Running of `aws-account-wide-terraform`

Using IAM profiles has the drawback that any process running on the VM can
get the same credentials. This model does not play well when it is required
to assign the credentials to specific processes running in different containers
(for example concourse, CF apps), as all the containers will have access to
the AWS IAM profile.

We'll need to maintain our own forks of some standard Concourse resources to
add support for IAM roles and instance profiles because the maintainers
don't wish to support this feature ([concourse/s3-resource/pull/22][]).
These resources include:

[concourse/s3-resource/pull/22]: https://github.com/concourse/s3-resource/pull/22

- [alphagov/paas-s3-resource](https://github.com/alphagov/paas-s3-resource)
- [alphagov/paas-semver-resource](https://github.com/alphagov/paas-semver-resource)

We'll need to use the office VPN to administer AWS when outside of the
office. This matches what we have to do to administer Concourse or Cloud
Foundry from outside the office. There are disaster recovery provisions for
the VPN if the office has connectivity problems.
