---
title: ADR018 - RDS broker restore last operation
---

# ADR018: RDS broker restore last operation

## Context

We use a completely stateless implementation for the RDS broker, as described in [ADR006](../ADR006-rds-broker).
So all the asynchronous operations on RDS instances were relying on executing a unique operation on AWS API, and querying the RDS instance status reported the AWS API.

But to implement the feature of restore from snapshot, we must execute several operations sequentially.

The broker must:
 1. Start the restore from snapshot, which can take minutes.
 2. Once finish, update several parameters of the instance (security groups, parameters, etc).
 3. Once that is finish, reset the master password of the RDS instance.
 4. Finally reset the passwords of the users previously bind in the original DB.

As the create operation is a asynchronous operation, the Cloud Controller API will periodically request the `LastOperation` endpoint to query the state of the restored instance.
The rds-broker must respond accordingly.

The Cloud Controller API includes logic to ensure the resiliance of a service creation, maintaining the workers that will poll the `LastOperation` until the service is created or there is timeout.

To implement this kind logic, some kind of state must be kept to track the changes on the instance.  Options are:
 * run a background house-keeping routine. This house-keeping should be resilient to rds-broker restarts and able to work with multiple rds-broker instances..
 * Use SNS and SQS, by subscribing to the [AWS events from RDS](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html). This requires a lot of additional work and integration effort.
 * Store the state in some database or k/v store.


## Decision


We decided:

 * Implement a state machine using the [AWS tags](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html) of the instance.
   We will add a list of tags for each pending operations to execute.
 * We make use of `LastOperation` to check the pending operations and perform them, to finally delete the corresponding tag to mark it as done.
   We assume that:
    * all the required operations are either asynchronous in the AWS API (eg. update instance) or quick to execute (e.g. reset bind user passwords)
    * that update the tags is atomic and synchronous.


## Status

Accepted

## Consequences

The `LastOperation` endpoint will be doing actual logic and updates in the Database.
