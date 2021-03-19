---
title: ADR037 - Automated certificate rotation
---

# ADR037: Automated certificate rotation

## Context
Our certificate rotation was a largely manual process, involving an operator triggering a series of Concourse pipeline jobs in a particular sequence. We did not have a routine for doing rotations, and would typically only do them as part of a CF upgrade.

The only means we had for knowing if a cert rotation was necessary was the `check-certificates` job, in the `create-cloudfoundry` Concourse pipeline, which would fail if any certificate had less than 30 days until it expired.

In Q2 2019 (August/September) we moved all of our platform secrets from AWS S3 to [Credhub](https://docs.cloudfoundry.org/credhub/). This covered third-party service credentials, platform passwords, and certificates. Since Credhub supports [certificate rotation](https://github.com/pivotal-cf/credhub-release/blob/master/docs/ca-rotation.md), we chose to implement automatic certificate rotation. This ADR contains details of how we did it.

## Decision

Credhub has the notion of a transitional certificate. As written in [their documentation](https://github.com/pivotal-cf/credhub-release/blob/master/docs/ca-rotation.md), a transitional certificate is 

> a new version that will not be used for signing yet, but can be added to your servers trusted certificate lists.

Our certificate rotation process is built around the setting and migration of the `transitional` flag, such that over a number of deployments an active certificate is retired and a new certificate is deployed, without downtime.

In order to make certificate rotation automatic, and require no operator interaction, it is implemented as a job at the tail end of the `create-cloudfoundry` pipeline; after acceptance tests and before releases tagging.

The new `rotate-certs` job has three tasks:

- `remove-transitional-flag-for-ca`
- `move-transitional-flag-for-ca`
- `set-transitional-flag-for-ca`

These three tasks are in reverse order of the process for rotating a certificate. If the tasks were ordered normally, the first task would set up the state for the second, and the second would set up the state for the third, and Bosh would be unable to deploy the certificates without downtime. However, here the tasks are explained in the proper order to make it easier to understand how a certificate is rotated. To understand how it happens in the pipeline, assume a Bosh deploy happens between each step.

`set-transitional-flag-for-ca` is the first step in the process. It iterates through all CA certificates in Credhub, looking for any expiring under 30 days. Any that are, are regenerated as transitional certificates. This results in Credhub holding two certificates for the same credential name: the expiring certificate, and the new certificate with the `transitional` flag.

`move-transitional-flag-for-ca` is the second step in the process, and has two jobs:

1. It finds all CA certificates in Credhub which have 2 values, where the oldest certificate does not have the `transitional` flag and the newer one does. For each of those, it swaps the `transitional` flag to the older certificate. Finally, it looks for any leaf certificates signed by the CA certificate and regenerates them using the new CA certificate.
2. It looks for any leaf certificates that are expiring in less than 30 days and regenerates them. This is a one step process and they are deployed on the next Bosh deploy.

`remove-transitional-flag-for-ca` is the third and final step in the process. It iterates through all of the CA certificates in Credhub, looking for any with 2 values, where the older certificate is marked as `transitional` and the newer certificate is not. It then removes the `transitional` flag from the older certificate, which has the effect of dropping the certificate.

The existing `check-certificates` job has also been modified to check for certificates that are expiring in less than 15 days. If a certificate fails this check, that should suggest to us that something has gone wrong in our certificate rotation process.

## Status
Accepted

## Consequences
Certificate rotations will happen more frequently, and we'll need to update our documentation surrounding certificate rotation and any documentation that references it.
