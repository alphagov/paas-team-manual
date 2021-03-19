---
title: ADR027 - Pipeline locking
---

# ADR027: Pipeline locking

## Context

In our Concourse pipelines a locking mechanism was required to prevent concurrent deploys. Concurrent deploys cause
problems because:

* one deployment may make changes which break another
* we have availability tests which tell us if a specific change causes app or API downtime
* Bosh has its own locking mechanisms, which mean concurrent deploys will fail.
* concurrent testing puts extra load on the platform and Concourse

## Decision

We decided to implement locking using the Concourse pool resource, AWS CodeCommit, and Terraform.

The Concourse pool resource was chosen because it is the Concourse-native solution for locking. This created a
dependency on having a Git repository for the lock, as this is how the pool resource is implemented. AWS CodeCommit was
chosen over Github for several reasons:

* client libraries for interacting with the necessary APIs were much more mature for AWS and this particular use case.
It saved a lot of work.
* Github would have required managing users and SSH keys, or tokens. AWS could use the existing instance profile of the
Concourse VM.
* Github would have meant the repository containing the locks would have been public.

Terraform was required to allow our pipelines (the Concourse instance profile) to manage AWS CodeCommit. We used a
pattern whereby we allow the creation of IAM users under a specific name prefix, and allow adding these users to a
predefined IAM group. The permissions of said group are defined in a private repository in Terraform configuration
which is ran manually. This limits the permissions the Concourse instance profile can grant to users.

## Status

Accepted

## Consequences

We have to store an SSH private key for Git in an environment's S3 state bucket. This key has to be created in the
pipeline and used as an input to Terraform configuration which generates the CodeCommit repository.
