---
title: ADR041 - BOSH access with mTLS
---

# ADR041: BOSH access with mTLS

## Context

In [ADR040 BOSH access without SOCKS](../ADR040-bosh-access-without-socks/) we removed the requirement for using a SOCKS5 proxy or SSH tunnel to access the User Account and Authentication Service (UAA).

We are moving towards a [zero trust network model](https://www.ncsc.gov.uk/blog-post/zero-trust-architecture-design-principles) and as part of this, we are removing the IP allow lists that have been in place. 

We discussed the proposed methods with IA and Cyber after reviewing the [RFC created as part of #169915408](https://docs.google.com/document/d/1XZsrNp88tOSyC_bjy1mg3Yyv2TkpKgYSjoYResGAbps/edit#heading=h.xscqoqxlc072)

## Decision

We will remove the reliance on IP allow lists for all services on the BOSH instance.

Mutual TLS will replace the allow lists.

Cyber prefer this method, as it give a much stronger authentication to the platform. This is due to authenticating both the individual and the machine that are accessing critical services.

## Implementation

We will implement Mutual TLS on the BOSH Director to gain access to the APIs it contains. We will achieve this by using an mTLS proxy such as [ghostunnel](https://github.com/square/ghostunnel), [mTLS-server](https://github.com/drGrove/mtls-server) or [HAProxy](https://www.loadbalancer.org/blog/client-certificate-authentication-with-haproxy/)

The following components will be accessible through 0.0.0.0/0 provided that the client presents a valid TLS certificate.

- UAA
- BOSH
- CredHub

![architecture](../images/adr452-bosh-access-with-mtls.svg)

By passing all the inbound connections through an mTLS proxy, we are able to keep multiple authentication factors in play. A DDoS attack on the proxy would not place additional load directly on the BOSH Director.

## Status

Accepted

## Consequences

We will no longer rely on IP allow lists when accessing the components on the BOSH Director.

Cyber can implement full alerting for this component.

We will not be using SSH access to the BOSH Director when carrying out daily operator tasks, which should reduce false alerting within Cyber.


