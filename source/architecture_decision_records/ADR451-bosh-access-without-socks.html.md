# BOSH access without SOCKS5 or SSH

## Context

To comply with [PCI Requirements](https://www.pcisecuritystandards.org/pci_security/maintaining_payment_security) we will remove the use of shared credentials anywhere in the platform.

We will use Single Sign On (SSO) to avoid credential sharing.

To enable SSO we will expose some of the APIs on the BOSH instance without using a SOCKS5 proxy. This is due to the SOCKS5 proxy not playing nicely with the VPN, which in turn creates a support risk

Discussion has taken place with both IA and with Cyber on the proposed methods after reviewing the [RFC created as part of #169915408](https://docs.google.com/document/d/1XZsrNp88tOSyC_bjy1mg3Yyv2TkpKgYSjoYResGAbps/edit#heading=h.xscqoqxlc072)

## Decision

We will remove the reliance on SOCKS5 or SSH tunnels for the UAA API endpoint so that we can remove the use of shared credentials.

With these in place we are unable to complete an SSO journey from one of our existing IDPs as the BOSH instance is not broswer accessible.

The current method will be replaced with Single Sign On in order to obtain a UAA token. This token is then used to interact with the rest of the APIs on the BOSH instance.

## Implementation

In the initial implementation we will place UAA on the bosh director in the internet using the IP Whitelist and using Google for SSO

Access to both BOSH and Credhub will remain via SSH Tunnels during this phase of implementation.

![architecture](../images/adr451-bosh-access-without-socks.svg)

By using this method we are retaining the benefit of using IP whitelisting whilst removing the shared credential that is in use.

## Status

Accepted

## Consequences

We will no longer rely on IP Whitelisting or SSH tunnels and have individual credentials for accessing UAA on the BOSH Director.

Full alerting can be undertaken by Cyber for this component.

We will not be using SSH tunnels to obtain UAA tokens.


