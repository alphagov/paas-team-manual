---
title: How to enable Github oAuth for your dev environments
---

# How to enable Github oAuth for your dev environments

This will enable anyone on the team to be able to log into your concourse

 - Create an [oAuth application](https://github.com/settings/applications/new)
 - Set your homepage URL to `https://deployer.<your env>.dev.cloudpipeline.digital`
 - Authorization callback URL should be `https://deployer.<your env>.dev.cloudpipeline.digital/sky/issuer/callback`
 - Store the client ID and Client secret in your personal pass store under the following locations `github.com/concourse/dev/client_id` and `github.com/concourse/dev/client_secret`
 - Run `make dev upload-github-oauth GITHUB_PASSWORD_STORE_DIR=<your pass dir> DEPLOY_ENV=<your env>`
 - Checkout Master and push the pipeline with the following command for deployer concourse
```
BRANCH=$(git rev-parse --abbrev-ref HEAD) make dev deployer-concourse pipelines SELF_UPDATE_PIPELINE=false
```
 - Run the `create-bosh-concourse` pipeline
 - once it has completed, login to team main using the login with Github button.
