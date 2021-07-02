---
title: Reducing Logit volume
---

# How to reduce Logit volume

We pay for our Logit stacks and there are limits placed on how much we can use. Sometimes we send too many logs to Logit. This page documents ways to reduce that.

## Invalid syslog drain URLs

If you search through the relevant stack for `"failed to resolve syslog drain host"` you may see loggregator sending these DNS resolution errors every 100ms, generating hundreds of thousands of log entries over the course of a day.
This error is generated when a tenant defines a user-provided service with a syslog drain URL that contains a hostname that cannot be resolved in DNS.

1. Identify all invalid syslog URLs in use by picking a log entry, taking the hostname and excluding it using a filter, and repeating this until Kibana shows no more results.
2. Iterate through all user-provided services in each deployment, grepping for syslog URLs matching the ones found in Logit. There is a script to list all user-provided services and their syslog drain URLs in [paas-cf.git scripts/all_syslog_service_instances.py](https://github.com/alphagov/paas-cf/blob/main/scripts/all_syslog_service_instances.py).
3. For each organisation affected, open a Zendesk ticket to the relevant Org Managers. You can find an example of this in ticket 4611228.
4. Wait for the tenants to sort out their user-provided service(s).