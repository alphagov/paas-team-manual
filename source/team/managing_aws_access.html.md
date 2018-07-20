# IAM

Each AWS account has [root account](http://docs.aws.amazon.com/general/latest/gr/root-vs-iam.html) credentials, which we don't use.

Instead we access AWS resources using [IAM](http://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html).

## IAM Roles

We use [IAM roles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) via [intance profiles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) on our EC2 instances to delegate particular restricted permissions to processes running on those instances.

## IAM Groups

We use [IAM groups](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html) to specify permissions for categories of user.

For example, contractors and civil servants are different groups.

## IAM Users

We create an [IAM user](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) for each team member, in each of our AWS accounts.

Each user has separate [access keys](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) which need to be present in the environment for the AWS commandline tools to work.

We have turned on [MFA](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html) for all team members.

# Temporary Credentials

We use [STS](http://docs.aws.amazon.com/STS/latest/APIReference/API_GetSessionToken.html) to provide [temporary credentials](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html) for command line access to AWS.

The long-lived access keys cannot be associated with MFA.

Since we require MFA to perform most AWS operations, we must use STS tokens generated using MFA instead.

We have a script [`create_sts_token.sh` in paas-cf](https://github.com/alphagov/paas-cf/blob/master/scripts/create_sts_token.sh) which manages token creation and storage for you.

Because you will have a user for each AWS account, but only one terminal session, it is up to you to integrate the generated keys into your session.

For example, you might add a function`:
```
export PAAS_CF_DIR="path/to/paas-cf"

sts() {
  "${PAAS_CF_DIR}/scripts/create_sts_token.sh" && source "${HOME}/.aws_sts_tokens/${AWS_ACCOUNT}.sh"
}
```

along with an alias per account:
```
alias aws_staging='
export AWS_DEFAULT_REGION=eu-west-1
export DEPLOY_ENV="staging"
export AWS_ACCOUNT="staging"
export AWS_ACCESS_KEY_ID=$(pass aws/staging/id)
export AWS_SECRET_ACCESS_KEY=$(pass aws/staging/secret)
sts
'
```

This approach would require you to store your long-lived credentials in a personal `pass` store. You may prefer an alternative approach, but this should give you an idea of what to do.
