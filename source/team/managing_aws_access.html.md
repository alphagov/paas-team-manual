# IAM

Each AWS account has [root account](http://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html) credentials, which we don't use.

Instead we access AWS resources using [IAM](http://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html).

## IAM Roles for VMs

We use [IAM roles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) via [intance profiles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) on our EC2 instances to delegate particular restricted permissions to processes running on those instances.

## IAM Roles for Humans

We use separate IAM roles for users on our team to use via AWS' assume-role
feature. See the [RE manual](https://reliability-engineering.cloudapps.digital/iaas.html#access-aws-accounts)
for details on how to do this.  The available role ARNs that you'll need for
this are documented [in paas-aws-account-wide-terrafom here](https://github.com/alphagov/paas-aws-account-wide-terraform/blob/master/doc/assume_role_arns.md)

## Role configuration

We manage all these IAM roles, and the corresponding policies using Terraform.
The config is in the [account-wide-terraform](https://github.com/alphagov/paas-aws-account-wide-terraform)
repo. This includes defining who is allowed to assume the above roles.
