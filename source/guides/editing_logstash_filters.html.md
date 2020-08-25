# Updating logstash filters

Sadly, there is no programmatic access to Logit's logstash filters.

## For new logit stacks...

If the logit stack is not a v6.x logstash (e.g. it's a v5.6 like the current PaaS stacks are)
the new filters need a plugin installed into logstash. You need to request this via logit support
(either through the web-based "chat" logit have once you've logged in or via their email address).
The plugin is for a filter called `alter`. v6.x logstash logit stacks have this plugin
installed by default. Such a request might look like:

Please could you install the "alter" filter plugin into logstash for the stack with id e3352477-f40c-41c5-be46-5c52c0e3de38?

## Process for generating logstash filters for Logit

We have instead come up with the following method.

1. Create your branch on PaaS-CF.
1. Make your changes and commit them as usual.
1. Two "upstream" repositories are used to generate the filter configuration. The required tags within each repository are specified in the Makefile (see the `logit-filters` target) - update them if required.
1. Run `make logit-filters` from the paas-cf directory (requires docker). This updates the `config/logit/output/generated_logit_filters.conf` file with the latest filter configuraton.
1. Check the diff for any potential gotchas.
1. [Log into logit via Google](https://reliability-engineering.cloudapps.digital/manuals/logit-io-joiners.html)[external link].
1. From the dashboard view, select the __Settings__ button for the stack you wish to modify.
1. Select __Logstash Filters__ and wait for the current page to load.
1. Select all of the existing filters and delete them.
1. Paste in your new filters and select __Validate__.
1. If the validation passes an __Apply__ button will appear. Select this button.
1. Wait for application of the filters to finish.

## Updating the components of the logstash filters

This information can be found in the [readme](https://github.com/alphagov/paas-cf/blob/master/config/logit/README.md)
