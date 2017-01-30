The PaaS technical documentation (for tenants) is moving to the new tech docs  system.

The latest version of the tech docs content has been put into the new system at [https://github.com/alphagov/paas-tech-docs](https://github.com/alphagov/paas-tech-docs) and is hosted on the PaaS at the temporary URL [https://paas-tech-docs.cloudapps.digital](https://paas-tech-docs.cloudapps.digital).

This new site will not replace the old docs until we have set it up to appear at the official URL - https://docs.cloud.service.gov.uk - and done the same thing for the product page.

Do not give the paas-tech-docs.cloudapps.digital address out to tenants or link to it until this process is completed.

See the README at [https://github.com/alphagov/paas-tech-docs](https://github.com/alphagov/paas-tech-docs) for details of how to use the new docs system. 

To deploy updates to the PaaS, make sure you have committed any changes you have made locally to Github, then run ``./script/deploy``. You must have the correct PaaS permissions to push an app to the org ``govuk-paas`` in the space ``docs``. The script will do the rest.