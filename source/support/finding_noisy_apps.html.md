# Finding noisy apps

We have had situations on the PaaS where a noisy neighbour issue has caused problems in the log stack and for other tenants. Identifying these can be hard.

We have enabled the noisy-neighbour-nozzle to aid in locating these.

Use;

1. Install the cf cli plugin `cf install-plugin -r CF-Community "log-noise"`
1. Run cf log-noise this will give you the top 10 noisiest logging apps on the platform

If you are looking for a particular app you can use `log-noise nn-nozzle nn-accumulator <app name>`
