---
title: Create a dev environment
---

# Tear down AWS resources

1. Log in to the AWS console and empty the following s3 buckets:
   1. gds-paas-{dev_env}-state
   2. {dev_env}-cf-droplets
   3. {dev_env}-cf-packages
   4. {dev_env}-cf-resources
2. Head to RDS, delete the rds broker dbs associated with the environment by searching for the deploy env
3. Iam: Remove all users associated with the deploy_env
4. In paas-boostrap run the teardown command e.g ```gds aws paas-dev-admin -- make dev02 teardown```
   1. run it a few times in case of dependency errors(e.g security groups)
5. Remove NAT gateways associated with the dev env VPC
6. Run the teardown command again e.g ```gds aws paas-dev-admin -- make dev02 teardown```
7. Remove the network interfaces associated with the dev env VPC
6. Run the teardown command again, you should see the VPC deleted e.g ```gds aws paas-dev-admin -- make dev02 teardown```
7. Navigate to codecommit in AWS console, us-east-1 and delete concourse-pool-{deploy_env}, remember to switch back to eu-west-1
8. Navigate to CloudWatch, delete all log groups associated with the deploy_env
9. Navigate to EC2, target groups, delete all target groups associated with the deploy_env
10. Navigate to ACM, delete all certificates associated with the deploy_env
11. Navigate to Elasticache, delete all subnet groups associated with the deploy_env
12. Navigate to WAF & Shield, delete all ACLs, then, IP sets associated with the deploy_env
13. Make sure the keypair is deleted

# Create new environment

## Create bosh and concourse

1. Start interactive shell with paas-dev-admin role: ```gds aws paas-dev-admin -- bash```
2. Set env vars that are set from the appropriate environment, bootstrap, globals and deployer-concourse make target: 
```
export PASSWORD_STORE_DIR=$HOME}/.paas-pass
export GITHUB_PASSWORD_STORE_DIR=${HOME}/.paas-pass
export GOOGLE_PASSWORD_STORE_DIR=${HOME}/.paas-pass
export DEPLOY_ENV=dev02
export SYSTEM_DNS_ZONE_NAME=${DEPLOY_ENV}.dev.cloudpipeline.digital
export SYSTEM_DNS_ZONE_ID=Z1QGLFML8EG6G7
export APPS_DNS_ZONE_NAME=${DEPLOY_ENV}.dev.cloudpipelineapps.digital
export APPS_DNS_ZONE_ID=Z3R6XFWUT4YZHB
export AWS_ACCOUNT=dev
export MAKEFILE_ENV_TARGET=dev
export ENABLE_DESTROY=true
export ENABLE_GITHUB=true
export CONCOURSE_AUTH_DURATION=48h
export SKIP_COMMIT_VERIFICATION=true
export AWS_DEFAULT_REGION=eu-west-1
export CYBER_PASSWORD_STORE_DIR=${HOME}/.paas-pass
export CONCOURSE_INSTANCE_TYPE=c7a.xlarge
export VAGRANT_SSH_KEY_NAME=${DEPLOY_ENV}-vagrant-bootstrap-concourse
export TARGET_CONCOURSE=bootstrap
export CONCOURSE_WEB_USER="admin"
export CONCOURSE_WEB_PASSWORD="$(
  aws sts get-caller-identity \
  | awk '$1 ~ /UserId/ {sub(/:.*$/, "", $2); print $2}' \
  | shasum -a 256 \
  | base64 \
  | head -c 32
)"
export BOSH_INSTANCE_PROFILE=bosh-director-cf
export CONCOURSE_TYPE=deployer-concourse
export CONCOURSE_HOSTNAME=deployer
export CONCOURSE_INSTANCE_TYPE=m7i.xlarge
export CONCOURSE_INSTANCE_PROFILE=deployer-concourse
export CONCOURSE_WORKER_INSTANCES=1
```
   1. Note to change the 'dev02'
3. Run vagrant environment script: 
   1. Navigate to paas-bootstrap
   2. ```vagrant/environment.sh > environment```
   3. put the above exports into environment
   4. put the output from ``echo $CONCOURSE_WEB_PASSWORD`` into environment
   5. source environment
4. Create key pair:
   1. Make sure you don't have a duplicate key. Typically, in the parent folder to paas-bootstrap
   2. ```aws ec2 create-key-pair --key-name "${VAGRANT_SSH_KEY_NAME}" | jq -r ".KeyMaterial" > "${VAGRANT_SSH_KEY}"```
   3. ```chmod 600 "${VAGRANT_SSH_KEY}"```
6. Launch EC2 instance from AWS console in eu-west-1 with the following settings
   ```
   Name: “<deploy-env> concourse”, e.g. “dev02 concourse”
   Tags:
   instance_group: concourse-lite
   deploy_env: <deploy_env>
   AMI: ami-0d64bb532e0502c46 (Ubuntu 24.04 LTS x86)
   Instance type: m7a.large
   Key pair: <deploy-env>-vagrant-bootstrap-concourse, e.g. dev02-vagrant-bootstrap-concourse
   Network settings:
   VPC: default
   Subnet: subnet-56a69a33 (for eu-west-1)
   Security group: select existing > create-dev
   Auto-assign public IP: true
   Storage:
   1 x 50GiB gp3
   Advanced details:
   IAM instance profile: arn:aws:iam::595665891067:instance-profile/concourse-lite (concourse-lite)
   Metadata version: V1 or V2 (token optional)
   Metadata response hop limit: 3
   ```
6. Find instance public IP, test SSH into instance:
   1. ```export CONCOURSE_LITE_INSTANCE_IP=<instance IP>```
   2. ```ssh -i ${VAGRANT_SSH_KEY} ubuntu@${CONCOURSE_LITE_INSTANCE_IP}```
   3. <ctrl+d> to terminate SSH connection
7. Copy relevant files:
   1. ```rsync -e "ssh -i ${VAGRANT_SSH_KEY}" environment ubuntu@${CONCOURSE_LITE_INSTANCE_IP}:```
   2. ```cd vagrant```
   2. ```rsync -e "ssh -i ${VAGRANT_SSH_KEY}" post-deploy.d/00-run-docker.sh ubuntu@${CONCOURSE_LITE_INSTANCE_IP}:```
   3. ```rsync -e "ssh -i ${VAGRANT_SSH_KEY}" docker-compose.yml ubuntu@${CONCOURSE_LITE_INSTANCE_IP}:```
8. Run concourse via docker on concourse lite instance:
   1. ``ssh -i ${VAGRANT_SSH_KEY} ubuntu@${CONCOURSE_LITE_INSTANCE_IP}``
   2. ``source environment``
   3. ``./00-run-docker.sh``
   4. <ctrl+d> to terminate SSH connection
9. Set up SSH tunnel to concourse lite instance:
    1. ``ssh -i ${VAGRANT_SSH_KEY} -L 8080:127.0.0.1:8080 -fN ubuntu@${CONCOURSE_LITE_INSTANCE_IP}``
    2. ``../concourse/scripts/pipelines.sh``
    3. ``../concourse/scripts/concourse-lite-self-terminate.sh``
10. Run the create-bosh-concourse pipeline
    1. Head to ``localhost:8080`` and trigger the update-pipeline job (Use the concourse creds from environment)
    2. ``cd ..``
    3. ``make ${DEPLOY_ENV} upload-all-secrets``
 11. Head to deployer.{deploy_env}.dev.cloudpipeline.digital
     1. run the pipeline

## Create Cloud Foundry

1. Head to paas-cf
2. Upload cloudfoundry pipelines with `gds aws paas-dev-admin -- make dev02 pipelines`
3. Connect to credhub with `gds aws paas-dev-admin -- make dev02 credhub`. Then follow the instructions to login to credhub, getting the passcode from the external hostname given when you first connect to credhub, e.g. https://bosh-uaa-external.dev02.dev.cloudpipeline.digital/passcode
4. Upload cloudfoundry secrets to credhub with `gds aws paas-dev-admin -- make dev02 upload-all-secrets`
5. Run the `generate-paas-admin-git-keys`, `generate-paas-billing-git-keys`, `generate-paas-aiven-broker-git-keys` and `generate-git-keys` jobs from the "operator" tab of the create-cloudfoundry pipeline