# Trial Accounts

This guide is for the technical work involved in managing trial and abandoned orgs. We are now enforcing a 3 month trial policy in order to reduce costs.

## How to get the data

1. Log into Prod
1. Run `./scripts/org-usage-report.sh > org_usage.csv`

expect to see some errors containing

```bash
jq: error (at <stdin>:1): Cannot iterate over null (null)
jq: error (at <stdin>:1): Cannot iterate over null (null)
```

These are from orgs that are created or removed during the data dump i.e. CATS and SMOKE test orgs.

## How to import the data

1. `docker run -d -p 5432:5432 --name postgres -e POSTGRES_PASSWORD= -v "$PWD:/var/downloads" postgres:9.5`
1. `psql -Upostgres -hlocalhost`
1. `create table orgdump (name text, guid text, created_at timestamptz, updated_at timestamptz, managers int, users int, running_apps int, stopped_apps int, services int, last_logon_time text, quota text, org_manager_emails text);`
1. `COPY orgdump FROM '/var/downloads/org_usage.csv' DELIMITER ',' CSV HEADER;`


## Trial Orgs

### How to query the data

To find orgs that are over 90 days old and are on the default quota:

```sql
SELECT * FROM orgdump
WHERE created_at < NOW() - INTERVAL '90 days'
AND quota like 'default'
ORDER BY created_at;
```

**At this point the data should be checked with the PM team before proceeding**

### To export the data for contacting the org managers run the following

```sql
COPY (select to_json(array_agg(t)) from (select * from orgdump where created_at < NOW() - INTERVAL '90 days' and quota like 'default' order by created_at) t)
TO '/var/downloads/old_orgs.json';
```

### To contact the org managers

1. Install node on your machine
1. Install the notify node client with `npm install --save notifications-node-client`

We have an up-to-date Notify template for this notification. However, it requires some word smithing before being used in anger.

```bash
NOTIFY_API_KEY="$(paas-pass notify/prod/api_key)" \
NOTIFY_TEMPLATE_ID="" \
node scripts/contact_orgs.js old_orgs.json
```

## Abandoned orgs

### How to query the data

To find orgs with nothing running:

```sql
SELECT * FROM orgdump
WHERE users = 0 or (running_apps + stopped_apps) = 0
ORDER BY created_at;
```

**At this point the data should be checked with the PM team before proceeding**

### To export the data for contacting the org managers run the following

```sql
COPY (select to_json(array_agg(t)) from (select * from orgdump where (users = 0 or (running_apps + stopped_apps) = 0) order by created_at) t) 
TO '/var/downloads/abandoned_orgs.json';
```

### To contact the org managers

This is a feature that should live in Pazmin, it will one day, but for now;

1. Install node on your machine
1. Install the notify node client with `npm install --save notifications-node-client`
1. Run the script:

  ```bash
  NOTIFY_API_KEY="$(paas-pass notify/prod/api_key)" \
  NOTIFY_TEMPLATE_ID="e81fbb68-8f13-44c8-9ff3-0d2020449f0d" \
  node scripts/contact_orgs.js abandoned_orgs.json
  ```
