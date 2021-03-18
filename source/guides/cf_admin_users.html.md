---
title: How to sign into your Cloud Foundry admin account
---

# How to sign into your Cloud Foundry admin account

Everyone in the team who is authorised for prod access gets their own admin
account in CI, staging and prod to avoid needing to share credentials and to be
able to attribute actions to individuals.

In order to ensure two factor authentication is used, we use our google apps accounts to authenticate:

`cf login -a api.SYSTEM_DOMAIN --sso`

This will give you a link to the UAA login page which lists identity providers.

Using the normal "Google" identity provider will give you global auditor
access.

Using the "Platform Administrators" identity provider will give you global
administrator access, which you should use only when necessary, for instance:

- during an incident
- to help a tenant debug a problem with their application
