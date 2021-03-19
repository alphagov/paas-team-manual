---
title: ADR044 - Remove IPSec
---

# ADR044: Remove IPSec

## Context

GOV.UK PaaS uses mutual TLS via routing-release between gorouter and apps.
This is a form of end-to-end encryption.

GOV.UK PaaS uses IPSec between gorouter and diego cells (which run apps).
This is a form of end-to-end encryption.

The [cf-dev mailing list](https://lists.cloudfoundry.org/g/cf-dev/message/9143) alleges 
that the IPSec release is no longer maintained.

## Decision

We will not run IPSec in our BOSH deployments.

## Status

Accepted.

## Consequences

End-to-end encryption between gorouter and apps will done solely by mTLS.
