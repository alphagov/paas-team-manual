# How to sign into your Cloud Foundry admin account

Everyone in the team who is authorised for prod access gets their own admin
account in CI, staging and prod to avoid needing to share credentials and to be
able to attribute actions to individuals.

In order to ensure two factor authentication is used, we use our google apps accounts to authenticate:

`cf login -a api.SYSTEM_DOMAIN --sso`
