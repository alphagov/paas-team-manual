# Restoring the Bosh Director
This guide will show you how to restore the bosh director and cells, in the event that it becomes unreachable or unresponsive.

## Contents
1. [Bootstrapping the director in another AZ](#bootstrapping-the-director-in-another-az)
2. [The director's database is gone](#the-director-39-s-database-is-gone)

## Bootstrapping the director in another AZ
1. Using `paas-bootstrap`, bootstrap a new deployer-concourse instance using the `BOSH_AZ` env var to specify the target AZ. `$ENV` is the environment you're targetting (e.g. dev or prod-lon).

```
BOSH_AZ=eu-west-2b make $ENV deployer-concourse bootstrap
```

3. Wait for the bootstrapper VM to come online, and access it at `localhost:8080`
4. Run the `create-bosh-concourse` pipeline from the left-hand edge

## The director's database is gone
In the event that the director's database is gone, it can be restored from the latest snapshot to get to back to a state from which the rest of the deployment can be fixed.

1. Find the latest snapshot of the director's database in the RDS console
2. Create a new database from this snapshot, using **exactly** the same name as set by Terraform in `paas-bootstrap/terraform/bosh/rds.tf`
3. Bootstrap a new deployer-concourse using `paas-bootstrap` in the same region.
4. Wait for the new database to be available.
5. Run the `create-bosh-concourse` pipeline from the left-hand edge. During the `bosh-terraform` step, Terraform will find the same-named database and configure its parameter group, security group etc correctly.
6. The director will be deployed with access to the correct database.
