# ADR041: BOSH access with mTLS

## Context

In [ADR040 BOSH access without SOCKS](../ADR040-bosh-access-without-socks/) we removed the requirement for using a SOCKS5 proxy or SSH tunnel to access UAA.

We are moving towards a [zero trust network model](https://www.ncsc.gov.uk/blog-post/zero-trust-architecture-design-principles) and as part of this are removing the IP whitelists that have been in place. 

Discussion has taken place with both IA and with Cyber on the proposed methods after reviewing the [RFC created as part of #169915408](https://docs.google.com/document/d/1XZsrNp88tOSyC_bjy1mg3Yyv2TkpKgYSjoYResGAbps/edit#heading=h.xscqoqxlc072)

## Decision

We will remove the reliance on IP Whitelisting for all services on the BOSH Instance.

The IP Whitelisting will be replaced with Mutual TLS.

This method is one that is prefered by Cyber, as it give a much stronger authentication to the platform. This is due to authenticating both the individual and the machine that are accessing critical services.

## Implementation

Mutual TLS will be implemented on the BOSH Director in order to gain access to the APIs contained. This will be achieved by using a mTLS proxy such as [ghostunnel](https://github.com/square/ghostunnel), [mTLS-server](https://github.com/drGrove/mtls-server) or [HAProxy](https://www.loadbalancer.org/blog/client-certificate-authentication-with-haproxy/)

The following components will be accessible via 0.0.0.0/0 provided that there is a valid TLS certificate presented by the client.

- UAA
- BOSH
- Credhub

![architecture](../images/adr452-bosh-access-with-mtls.svg)

By passing all the inbound connections through an mTLS proxy we are able to keep multiple authentication factors in play and in the event of a DDoS attack on the proxy it does not place additional load directly on the BOSH Director.

## Status

Accepted

## Consequences

We will no longer rely on IP Whitelisting when accessing the components on the BOSH Director.

Full alerting can be undertaken by Cyber for this component.

We will not be using SSH access to the BOSH Director when carrying out daily operator tasks which should reduce false alerting within Cyber.


