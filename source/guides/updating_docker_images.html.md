---
title: Updating Docker Images
---

# Updating Docker Images

## Making changes to docker-cloudfoundry-tools repo

Push the relevant changes to your docker image in a branch of the docker-cloudfoundry-tools repo

```
git clone git@github.com:alphagov/paas-docker-cloudfoundry-tools.git
cd paas-docker-cloudfoundry-tools
git checkout -b "test_docker_branch"
<make changes>
git add -A
git commit -m "description of my changes"
git push --set-upstream origin test_docker_branch
```

## Trigger the build

Creating a PR for this branch will trigger a new build for each docker image in the repo.

eg: https://github.com/alphagov/paas-docker-cloudfoundry-tools/pull/new/test_docker_branch

Look at the github actions to confirm build success

eg: https://github.com/alphagov/paas-docker-cloudfoundry-tools/actions

Take a note of the commit ref which will be used to tag the newly build docker images

```
git log

commit 0a8c473a98866f99789a382ff8edbb324f6e35f0 (HEAD -> test_docker_branch, origin/test_docker_branch)
Author: Jack Joy <jack.joy@digital.cabinet-office.gov.uk>
Date:   Tue Jan 21 12:48:34 2024 +0000

    description of my changes
```

## Test new docker image in paas-bootstrap and paas-cf

create branches for each of these repos and update the tags for the relevant docker images

eg:
```
GDS11779:paas-bootstrap jack.joy$ git diff
diff --git a/concourse/tasks/delete-ssh-keys.yml b/concourse/tasks/delete-ssh-keys.yml
index ad05cbb..4b4480e 100644
--- a/concourse/tasks/delete-ssh-keys.yml
+++ b/concourse/tasks/delete-ssh-keys.yml
@@ -4,7 +4,7 @@ image_resource:
   type: registry-image
   source:
     repository: ghcr.io/alphagov/paas/awscli
-    tag: 10f7bb56a8f4c0493acdd303ca08571ef3ecc8e9
+    tag: 0a8c473a98866f99789a382ff8edbb324f6e35f0
 inputs:
   - name: paas-bootstrap
 run:
```

Replace each instance of the old tag (10f7bb56a8f4c0493acdd303ca08571ef3ecc8e9) for the new tag (0a8c473a98866f99789a382ff8edbb324f6e35f0)

Push the changes to the branches and configure the pipelines to use these branches in your dev environment

eg:
```
gds-cli aws paas-dev-admin -- make dev04 deployer-concourse pipelines DEPLOY_ENV=dev04 BRANCH=test_docker_branch
```

Run the pipelines to test the changes

## Merge the docker-cloudfoundry-tools changes

Have the PR approved and merge it into main

Once the build has run, update the docker tag references in the paas-bootstrap and paas-cf repos again with the new tag and push the changes

Get the PRs approved and merge
