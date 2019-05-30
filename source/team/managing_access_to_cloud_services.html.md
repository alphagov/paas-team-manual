# AWS
## IAM

Each AWS account has [root account](http://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html) credentials, which we don't use.

Instead we access AWS resources using [IAM](http://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html).

### IAM Roles for VMs

We use [IAM roles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) via [intance profiles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) on our EC2 instances to delegate particular restricted permissions to processes running on those instances.

### IAM Roles for Humans

We use separate IAM roles for users on our team to use via AWS' assume-role
feature. See the [RE manual](https://reliability-engineering.cloudapps.digital/iaas.html#access-aws-accounts)
for details on how to do this.  The available role ARNs that you'll need for
this are documented [in paas-aws-account-wide-terrafom here](https://github.com/alphagov/paas-aws-account-wide-terraform/blob/master/doc/assume_role_arns.md)

### Role configuration

We manage all these IAM roles, and the corresponding policies using Terraform.
The config is in the [account-wide-terraform](https://github.com/alphagov/paas-aws-account-wide-terraform)
repo. This includes defining who is allowed to assume the above roles.

# Aiven

We use Aiven for our Elasticsearch backing service.  We log in to Aiven using
the [Aiven Console](https://console.aiven.io/).

We have 4 separate projects:

- Dev
- CI
- Staging
- Prod

# Microsoft Azure

We use Microsoft Azure for single sign-on. We log into Azure using the [Azure
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
