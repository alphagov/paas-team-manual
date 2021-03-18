---
title: ADR009 - X-Forwarded- headers
---

# ADR009: X-Forwarded- headers

This has been superceded: the first option is now used to encrypt traffic
between the ELB and HAProxy (see [ADR016](../ADR016-end-to-end-encryption))

## Context

We need to pass correct client IP and requested protocol to applications deployed to the platform. To achieve this we want to use X-Forwarded-For and X-Forwarded-Proto headers.
In the current setup we've got HAProxy behind ELB to allow insert HSTS headers, and ELB is configured in SSL mode (not HTTPS) because it does not support WebSockets. In SSL/TCP mode ELB is not able to set any `X-Forwarded` header.

The solution is to use ProxyProtocol to pass information about recorded client IP and protocol to HAProxy which can set required headers for us. Unfortunately [ELB sets ProxyProtocol header inside SSL stream and HAProxy expects it outside](http://serverfault.com/questions/775010/aws-elb-with-ssl-backend-adds-proxy-protocol-inside-ssl-stream).

There are two options to workaround this:

 * Use a more complex configuration of HAProxy with two frontends/listeners chained
 * Disable SSL between ELB and HAProxy


## Decision

We have decided to disable SSL encryption between internal IP of ELB and HAProxy to allow us to use ProxyProtocol.
We don't think this has any significant increase in risk because:

* gorouter to cell traffic is already HTTP (it has to be because we can't do termination in app containers)
* the inner interface of the ELB is on an internal network in our VPC

## Status

Accepted

## Consequences

The http traffic between ELB and HAProxy will not be encrypted.
