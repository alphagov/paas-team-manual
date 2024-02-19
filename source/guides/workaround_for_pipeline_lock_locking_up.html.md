---
title: Workaround for pipeline lock mechanism hanging
---

# Workaround for pipeline lock mechanism hanging

## Identifying when the issue is occurring

In certain circumstances the mechanism that ensures a single deployment run has exclusive access to the concourse pipelines, can itself hang, thereby never releasing the lock for subsequent runs to proceed.

The issue can be seen when a deployment has been kicked off, there are no other deployments still running, but the pipeline-lock is not being released. Occurances are not common but common enough to require this article.

## BOSH Recreate the Concourse VMs

The best workaround we currently have is rather heavy handed, but does solve the problem. Using the BOSH cli, we recreate the concourse and concourse worker VMs, thereby resetting the state.

```
$ gds-cli aws paas-dev-admin -- make dev bosh-cli DEPLOY_ENV="dev04"

Enter MFA code for arn:aws:iam::xxxxxxxx:mfa/xxxxxxxx@digital.cabinet-office.gov.uk: xxxxxx
Getting BOSH settings
Opening SSH tunnel

  ,--.                 .--.
  |  |-.  ,---.  ,---. |  '---.
  | .-. '| .-. |(  .-' |  .-.  |
  | '-' |' '-' '.-'  ')|  | |  |
   '---'  '---' '----' '--' '--'
  1. Run 'bosh login'
  2. Skip entering a username and password
  3. Enter the passcode from https://bosh-uaa-external.dev04.dev.cloudpipeline.digital/passcode

BOSH (dev04) $ bosh login
 
Using environment 'bosh.dev04.dev.cloudpipeline.digital'

Email ():
Temporary Authentication Code ( Get one at https://bosh.dev04.dev.cloudpipeline.digital:8443/passcode ) ():
Password ():

Successfully authenticated with UAA

Succeeded

BOSH (dev04) $ bosh -d concourse vms

Using environment 'bosh.dev04.dev.cloudpipeline.digital' as user 'xxxxxxxx@digital.cabinet-office.gov.uk'

Task 260165. Done

Deployment 'concourse'

Instance                                               Process State  AZ  IPs             VM CID               VM Type           Active  Stemcell
concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7  running        b1  10.0.0.103      i-0c5df587c27d5d3c4  concourse_worker  true    bosh-aws-xen-hvm-ubuntu-jammy-go_agent/1.309
concourse/cd83da7e-525b-4177-a2dc-7169892c1be8         running        b1  52.211.196.151  i-032e8d53aeeee59c5  concourse         true    bosh-aws-xen-hvm-ubuntu-jammy-go_agent/1.309
                                                                          10.0.0.106

2 vms

Succeeded

BOSH (dev04) $ bosh -d concourse recreate concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7

Using environment 'bosh.dev04.dev.cloudpipeline.digital' as user 'xxxxxxxx@digital.cabinet-office.gov.uk'

Using deployment 'concourse'

Continue? [yN]: y

Task 260183

Task 260183 | 10:06:31 | Preparing deployment: Preparing deployment (00:00:01)
Task 260183 | 10:06:32 | Preparing deployment: Rendering templates (00:00:03)
Task 260183 | 10:06:35 | Preparing package compilation: Finding packages to compile (00:00:00)
Task 260183 | 10:06:35 | Updating instance concourse-worker: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:06:35 | L executing pre-stop: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:06:36 | L executing drain: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:10:29 | L stopping jobs: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:10:32 | L executing post-stop: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:15:01 | L installing packages: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:15:33 | L configuring jobs: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:15:33 | L executing pre-start: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:15:34 | L starting jobs: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary)
Task 260183 | 10:16:04 | L executing post-start: concourse-worker/89f7a596-7a06-4cae-8565-981af56840e7 (0) (canary) (00:09:29)

Task 260183 Started  Mon Feb 19 10:06:31 UTC 2024
Task 260183 Finished Mon Feb 19 10:16:04 UTC 2024
Task 260183 Duration 00:09:33
Task 260183 done

Succeeded

BOSH (dev04) $ bosh -d concourse recreate concourse/cd83da7e-525b-4177-a2dc-7169892c1be8

Using environment 'bosh.dev04.dev.cloudpipeline.digital' as user 'xxxxxxxx@digital.cabinet-office.gov.uk'

Using deployment 'concourse'

Continue? [yN]: y

Task 260216

Task 260216 | 10:22:47 | Preparing deployment: Preparing deployment (00:00:01)
Task 260216 | 10:22:48 | Preparing deployment: Rendering templates (00:00:01)
Task 260216 | 10:22:49 | Preparing package compilation: Finding packages to compile (00:00:01)
Task 260216 | 10:22:50 | Updating instance concourse: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:22:50 | L executing pre-stop: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:22:50 | L executing drain: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:23:40 | L stopping jobs: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:23:53 | L executing post-stop: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:26:18 | L installing packages: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:26:49 | L configuring jobs: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:26:49 | L executing pre-start: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:26:50 | L starting jobs: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary)
Task 260216 | 10:27:20 | L executing post-start: concourse/cd83da7e-525b-4177-a2dc-7169892c1be8 (0) (canary) (00:04:30)

Task 260216 Started  Mon Feb 19 10:22:47 UTC 2024
Task 260216 Finished Mon Feb 19 10:27:20 UTC 2024
Task 260216 Duration 00:04:33
Task 260216 done

Succeeded
```
