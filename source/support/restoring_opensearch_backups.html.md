---
title: Restoring Opensearch backups
---

# Restoring Opensearch backups

There is no direct way for us to restore Opensearch backups either via the API or console.

In order to have a bakup restored you will need to open a support ticket with Aiven via [support@aiven.io](mailto:support@aiven.io) requesting a restoration of a backup they will need to know the instance ID `prod-$(cf service <servicename> --guid)` and the time of the backup you would like restored.

The Web interface only shows the latest backup, they are taken on a 2 hourly basis and retained as follows;

- Startup (our tiny plan): 2 days
- Business (our small plan): 14 days

If you are not sure which time, ask for a list of the available backups for the instance ID in question.
