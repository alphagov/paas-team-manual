---
title: ADR032 - SSL-only for applications and cf endpoints
---

# ADR032: SSL-only for applications and cf endpoints

## Context

Note: This has been superceeded. See [Status](#status) below.

It is expected for the government websites to be secure and keep the user
interactions private. Because that we want to enforce all communications to
any application and to the platform endpoints to use only and always HTTPS,
as [it is described in the Gov Service Manual](https://www.gov.uk/service-manual/technology/using-https).

When a user inputs a website name without specifying the
protocol in the URL, most browsers will try first the HTTP protocol by default.
Even if the server always redirect HTTP to HTTPS, an initial
unprotected request including user information will be transferred
in clear: full URL with domain, parameter, [cookies without secure flag](https://en.wikipedia.org/wiki/HTTP_cookie#Secure_and_HttpOnly)
or browser meta-information.

[HTTP Strict Transport Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security)
mitigates this issue by instructing modern browsers that support it to
always connect using HTTPS.
This is also a [requirement in the service manual](https://www.gov.uk/service-manual/technology/using-https).

There is still a potential initial unprotected HTTP request that might happen
before retrieve the HSTS headers or after the specified HSTS `max-age`.
To solve this issue, the root domain can be added to
[HSTS preload list](https://hstspreload.appspot.com/) which will be used by most
common browsers.

Currently the only way to avoid any clear text HTTP interaction is closing or
dropping any attempt to connect to the port 80 at TCP level.

Although not all application deployed on the PaaS will be "services"
as in the service manual meaning, we must not allow HTTP to make
it easier to service owners to comply with this requirements.

## Decision

We will only open port 443 (HTTPS) and drop/reject any TCP connection to TCP port 80 (HTTP).

We will implement and maintain HSTS preload lists for our production domains.


## Status

Superceeded by [ADR033](../ADR033-redirect-http-for-applications)

## Consequences

We must configure and maintain our domain in the HSTS preload lists.

Users of browsers which do not support HSTS, or HSTS preload lists, will not
be able to connect to the sites without specify the protocol `https://` in
the URL. This only happens when the user manually inputs the URL in the
browser.




