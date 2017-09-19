Currently the Cloud Controller database (api), UAA, BBS, and Locket are all colocated on a single RDS Postgres instance. Below is guidance on how the backups work and how you can restore from them.

Before embarking on any restoration make sure to follow the [Notifying tenants guidance](https://government-paas-team-manual.readthedocs.io/en/latest/team/notifying_tenants/) to communicate any downtime or disruption. Also, make sure to pause any Concourse pipelines.

## How backups are taken

We take near-real-time backups of our platform's RDS instances (such as `prod-cf`.) This is done with the point-in-time backup feature of AWS RDS. The Cloud Foundry databases are all in the `${DEPLOY_ENV}-cf` instance.

With point-in-time backups you can create a new RDS instance matching the state your original instance had at a time of your choice. For instance, you could create a new instance whose contents are identical to what `prod-cf` had at 7:22:15pm last Friday.

In production and staging we retain 35 days of point-in-time backups (the maximum possible.) They are not enabled in dev. Point-in-time backups enabled in the AWS Console will be disabled by the next pipeline run, but you can take snapshots in the AWS Console or edit the Terraform manifest.

[Amazon's documentation](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html) is confusing. Daily snapshots of the RDS instances are taken, and discussion elsewhere [[1](http://www.iheavy.com/2011/07/15/point-in-time-recovery-what-is-it-and-why-is-it-important/), [2](https://stackoverflow.com/a/36205893)] indicates that transaction logs are used to advance these to the exact time chosen to restore.

## Restoring an entire RDS instance

You should not restore the entire RDS instance for the following reasons:

* RDS can only restore to new instances, it will not overwrite the existing instance. To configure CloudFoundry to use the restored instance we would have to manually run Terraform changes to track the new state. See the [Pivotal story](https://www.pivotaltracker.com/n/projects/1275640/stories/149929492) for further details.
* Backups and snapshots include state databases. The platform may behave strangely if provided with old state.
    * `locket` stores distributed lock information. At the time of writing we do not seem to be use it, but it may be used in future.
    * `bbs` stores the state of what is currently running.

Restoring the Cloud Foundry databases:

* `uaa` and `api` can be restored individually using the instructions below.
* `locket` and `bbs` must exist but their contents may not want restoring. See the notes above.

## How to create an instance from a backup

AWS cannot restore a point-in-time backup or a snapshot to an existing RDS instance. Instead you must create a new one.

To create an instance using a point-in-time backup:

1. Follow the AWS documentation on [restoring from a point in time](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html) to create a new RDS instance. This is best done in the AWS Console. You cannot restore the backup directly over the top of the currently running instance, despite the use of the word restore.
2. The new instance will be created with the default security group. Use the console to [modify the instance](henry-cf-pivotal-149929492) to use the `${DEPLOY_ENV}-cf-rds` security group. This will allow you to access the instance by tunneling via Concourse.

## Restoring an individual table or database

Below are some generic instructions on restoring the CF RDS instance databases or tables. They are generic as we did not agree on specific situations we are guarding against. For example, restoring to fix corrupted data would be very different to fixing accidental deletion of a table/database.

**1.** First, follow the instructions above on creating an RDS instance from a backup. This instance will provide the data for the restoration.

**2.** Create a tunnel to the backup via Concourse:

```
# CHANGEME to your paas-cf directory
cd /path/to/paas-cf

# CHANGEME to the hostname of the RDS instance you
# are restoring from. This can be found in the AWS console.
db_hostname='some-db-instance-name.colgoy4debsd.eu-west-1.rds.amazonaws.com'

make tunnel TUNNEL=5432:${db_hostname}:5432
```

**3.** The password for the instance created from a snapshot will be the same as the original:

```
db_password=$(
  concourse/scripts/val_from_yaml.rb \
  secrets.cf_db_master_password \
  <(aws s3 cp s3://gds-paas-${DEPLOY_ENV}-state/cf-secrets.yml -) \
)
```

**4.** Run commands from Docker. The following example dumps a single table in binary format. You can omit the `--table` option if you want the entire database, and you can use `-Fp` instead of `-Fc` to produce a plain-text output. Plain-text makes it easier to see what it intends to do, but doesn't work fully with `pg_restore`.

```
docker pull postgres:9.5-alpine
docker run --rm -ti \
  -e PGPASSWORD="${db_password}" \
  postgres:9.5-alpine \
  pg_dump -Fc \
    --host=docker.for.mac.localhost \
    --username=dbadmin \
    --dbname=<db_name> \
    --table <table_name> > "/tmp/<table_name>.sql"
```

**5.** Close the tunnel and create a new one to your CloudFoundry RDS instance:

```
make stop-tunnel TUNNEL=5432:${db_hostname}:5432

db_hostname=$(
  aws s3 cp s3://gds-paas-${DEPLOY_ENV}-state/cf.tfstate - \
  | jq -r '.modules[].outputs["cf_db_address"].value' \
)
make tunnel TUNNEL=5432:${db_hostname}:5432
```

**6.** To restore into the CloudFoundry database you can use Docker, as per the instructions above, but swapping your `pg_dump` command for `pg_restore` with the necessary options:

```
pg_restore --dbname=<db_name> --host=docker.for.mac.localhost --username=dbadmin <filename>
```

You can use the `--data-only` option for situations where you have the schema but need to restore data. You can use the `--table` option to restore individual tables, but make sure to read `man pg_restore` for its caveats. This approach will work for deleted tables and databases, but not corrupted ones.

If you have corrupted data you may need to log in first to do manual cleanup, in which case use this command from Docker to get an interactive shell:

```
psql \
  --host=docker.for.mac.localhost \
  --username=dbadmin \
  --dbname=<db_name>
```
