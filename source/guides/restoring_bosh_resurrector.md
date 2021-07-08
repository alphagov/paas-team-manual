---
title: Restoring the BOSH Resurrector
---

# Restoring the BOSH Resurrector
This guide will show you how to restore the BOSH resurrector, in the event that it has been disabled in an AZ outage.

## What if the resurrector isn't running?

Its main responsibility, is taking care of the VMs and re-creating them when they become inaccessible.

BOSH is doing a lot of work for us and we should trust its judgement, to provide stable platform to our tenants.

In addition, our [Concourse pipelines][1] will be checking up on the resurrector, and if that isn't enabled, the pipelines will fire [nagging emails][2] as a reminder.

## What do I do?

1. Using `paas-bootstrap`, you will need to gain access to BOSH's CLI. This can be achieved by running the following command:

```
make $ENV bosh-cli
```

This action requires you to be in a range of approved IPs - like a VPN.

2. When your environment is ready, you will need to log into BOSH. Follow the instructions in your terminal, to obtain one time password.

```
bosh login
```

This action, will be recorded!

3. Enable the resurrector manually with the follwing command:

```
bosh update-resurrection on
```

The next time, the job checking for resurrector being enabled, should succeed and not send out an email.

[1]: https://github.com/alphagov/paas-cf/blob/b91dd05607b239150fa2e37180ad1de60c398410/concourse/pipelines/create-cloudfoundry.yml#L1970-L2007
[2]: https://github.com/alphagov/paas-cf/blob/b91dd05607b239150fa2e37180ad1de60c398410/concourse/scripts/nagging_email.sh#L15-L32
