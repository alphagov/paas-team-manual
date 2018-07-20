# Documentation for tenants (`paas-tech-docs`)

The PaaS tech docs content lives in [https://github.com/alphagov/paas-tech-docs](https://github.com/alphagov/paas-tech-docs) and is hosted on the PaaS as the `paas-tech-docs` app (org `govuk-paas`/space `docs`).

A CDN has been used to serve the content of this site at https://docs.cloud.service.gov.uk which is the URL you should use.

See the README at [https://github.com/alphagov/paas-tech-docs](https://github.com/alphagov/paas-tech-docs) for details of how to use the new docs system.

Updates to the git master branch should be deployed automatically by [this concourse pipeline](https://concourse.build.ci.cloudpipeline.digital/teams/main/pipelines/paas-tech-docs).

Note that the CDN has a TTL of 30 seconds, so after an update has been deployed, you won't see your changes for 30 seconds or so.
