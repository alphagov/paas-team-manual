Context
=======

We will only [serve HTTPS traffic, keeping TCP port 80 (HTTP) closed and use HSTS preload lists](ADR443-ssl-only-for-applications-and-cf-endpoints.md).

To add our domains to [HSTS preload lists](https://hstspreload.appspot.com/), there are these requirements:

 1. Serve a valid certificate.
 2. Redirect from HTTP to HTTPS on the same host.
 3. Serve all subdomains over HTTPS (actually checks for `www.domain.com`)
 4. Serve an HSTS header on the base domain for HTTPS requests:

We need an endpoint to provide these requirements.

Our Cloud Foundry app endpoint already [serves the
right HSTS Security header with HAProxy](ADR008-haproxy-for-request-rewriting.md)
and could be configured to serve the additional `preload` and `includeSubDomains` flags,
but we cannot use it because we keep port 80 (HTTP) closed for this endpoint.
We can implement a second ELB to listening on HTTP and HTTPS and use
HAProxy to do the HTTP to HTTPS redirect and serve the right header.
But this increases our dependency on the HAProxy service.

We must serve from the root domain (or apex domain), but it is not allowed to
serve [CNAME records in the root/apex domain](http://serverfault.com/questions/613829/why-cant-a-cname-record-be-used-at-the-apex-aka-root-of-a-domain). We must configure A records in this domain. This can be
an issue when serving the service using ELB or CloudFront.

Decision
========

 * We will implement a basic [AWS API Gateway](https://aws.amazon.com/api-gateway/)
   with a default [MOCK response](https://aws.amazon.com/about-aws/whats-new/2015/09/introducing-mock-integration-generate-api-responses-from-api-gateway-directly/)
   that returns the right HTTP header `Strict-Transport-Security`. The actual
   content of the response is irrelevant, it can be a 302.
   A [Custom Domain Name](http://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html),
   which creates a [AWS Cloud Front distribution](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-overview.html),
   will provide public access to this API.

 * We will use [AWS Route 53 `ALIAS` resource record](http://docs.aws.amazon.com/Route53/latest/APIReference/CreateAliasRRSAPI.html)
   to [serve the IPs of the AWS Cloud Front distribution as A records](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-cloudfront-distribution.html).


Status
======
Accepted

Consequences
============

To setup AWS API Gateway Domain Names, it is required access to the SSL certificates. There is the option of uploading the certificates in a different step and create the AWS Cloud Front distribution manually.

