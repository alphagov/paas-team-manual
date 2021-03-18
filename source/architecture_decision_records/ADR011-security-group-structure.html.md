---
title: ADR011 - Security group structure
---

# ADR011: Security group structure

## Context

In https://www.pivotaltracker.com/story/show/115252309 we described a pattern
for defining security groups between services and the VMs that connect to
them. This involved creating a client security group for each service that
the service allowed connections from. This client security group was then
applied to the VMs that needed to be able to connect.

This has the problem that in some cases we would need to add several client
security groups to a given VM, and we are at risk of running into the AWS
limits (by default it's a max of 5 groups per interface).

## Decision

We will use an alternative approach where a security group is defined for each
component (or component group) in the system. Services then define rules
allowing connections from the components that need access. There are some
instances where a component will be both a client of other services and a
provider of a service. We will use the same security group for both of these
roles.

This approach has a number of advantages:

* The number of security groups applied to a VM is driven by the number of
  components on that VM, not the number of things that they need to connect to.
  The number of components is likely to be small, and we're better able to
  control this that we can control the number of things a  component talks to.
* It's easier to see what components connect to a given service by looking at
  the rules for that service's security group.
* When moving a component between VMs it's much clearer which security groups
  need to move with it.

## Status

Accepted

## Consequences

* This will enable us to avoid hitting the AWS limits for the number of
  security groups applied to a given interface.
* It will make it clearer which components are allowed to connect to a given
  service.
* There will be some work to update our existing groups to use this pattern.

There are some potential issues:

* There's the possibility for cycles in the Terraform dependency graph when we
  have 2 components that both initiate connections to each other. This can be
  avoided by using the `aws_security_group_rule` Terraform resource instead of
  defining the rules inline in the `aws_security_group`.

* When looking at a given VM, it's harder to see what services it connects to.
  This is not seen as a major problem because it should be possible to create
  tooling to visualise this without much effort.
