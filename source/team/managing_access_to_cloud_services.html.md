---
title: AWS
---

# AWS
## IAM

Each AWS account has [root account](http://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html) credentials, which we don't use.

Instead we access AWS resources using [IAM](http://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html).

### IAM Roles for VMs

We use [IAM roles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) via [intance profiles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) on our EC2 instances to delegate particular restricted permissions to processes running on those instances.

### IAM Roles for Humans

See [the reliability engineering documentation on how to access AWS accounts](https://reliability-engineering.cloudapps.digital/iaas.html#access-aws-accounts).

We have a number of IAM roles intended for operators of the platform to use.

You should always try to use the least privileged role possible. This helps mitigate several risks, such as:

* accidentally performing a destructive action due to a typo (e.g. running `terraform destroy -auto-approve` against the wrong account)
* compromise of a privileged token leading to a serious security incident

#### Operator

The `Operator` role grants a minimal set of mostly read-only permissions.

Wherever possible this should be the only role we use to interact with
non-dev environments. Actions which require higher privileges should usually
be done through version controlled changes deployed through our pipelines.

There are some actions which are not deployed through the pipelines for which
the operator role is insufficient. For example:

* running AWS account wide terraform (requires Admin)
* performing maintenance on tenant databases (requires Admin)

In these situations it is acceptable to use an Admin role.

#### Admin

The `Admin` role grants full IAM access to an account. It should only be used
in production when the operator role is not sufficient.

Before using the Admin role in a production environment you should think
carefully about whether you could make a version controlled change deployed
through our pipelines instead of using an ad hoc AWS session.

### Role configuration

We manage all these IAM roles, and the corresponding policies using Terraform.
The config is in the [account-wide-terraform](https://github.com/alphagov/paas-aws-account-wide-terraform)
repo. This includes defining who is allowed to assume the above roles.

# Aiven

We use Aiven for our Opensearch backing service.  We log in to Aiven using
the [Aiven Console](https://console.aiven.io/).

We have 4 separate projects:

- Dev
- CI
- Staging
- Prod

# Microsoft Azure

We use Microsoft Azure to provide single sign-on for some tenants. We log into Azure using the [Azure
Portal](https://portal.azure.com).

We have 4 separate Active Directory apps under the
digital.cabinet-office.gov.uk Azure account:

- Dev
- Staging London
- Prod London
- Prod

# Google Cloud

We use Google Cloud for single sign-on. We log into Google using the [Google
Cloud Console](https://console.cloud.google.com/).

We have 2 separate projects under the digital.cabinet-office.gov.uk Azure
account:

- [GOV.UK PaaS](https://console.cloud.google.com/home/dashboard?project=govuk-paas)
- [paas-development](https://console.cloud.google.com/home/dashboard?project=paas-development-210707)

Our single sign-on apps are managed in [`GOV.UK PaaS`](https://console.cloud.google.com/apis/credentials?folder=&organizationId=&project=govuk-paas)
