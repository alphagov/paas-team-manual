The PaaS technical documentation (for tenants) is moving to the new tech docs  system.

The latest version of the tech docs content has been put into the new system at [https://github.com/alphagov/paas-tech-docs](https://github.com/alphagov/paas-tech-docs) and is hosted on the PaaS as the `paas-tech-docs` app (org `govuk-paas`/space `docs`).

A CDN has been used to serve the content of this site at https://docs.cloud.service.gov.uk which is the URL you should use.

See the README at [https://github.com/alphagov/paas-tech-docs](https://github.com/alphagov/paas-tech-docs) for details of how to use the new docs system. 

To deploy updates to the PaaS, make sure you have committed any changes you have made locally to Github, then run ``./script/deploy``. You must have the correct PaaS permissions to push an app to the org ``govuk-paas`` in the space ``docs``. The script will do the rest.

Note that the CDN has a TTL of 30 seconds, so after you have pushed an update, you won't see your changes for 30 seconds or so.