
Everyone in the team who is authorised for prod access gets their own admin
account in CI, staging and prod to avoid needing to share credentials and to be
able to attribute actions to individuals.

In order to ensure two factor authentication is used, we use our google apps accounts to authenticate:

`cf login -a api.SYSTEM_DOMAIN --sso`

At present, a [bug](https://github.com/cloudfoundry/uaa/issues/562) in UAA means that you will see an error like this:

![Screenshot showing invalid redirect_uri error from google](https://camo.githubusercontent.com/4df4a3816727d2d6376df5d8bfe0f416446e22ae/68747470733a2f2f692e696d6775722e636f6d2f543268777076752e706e67)

to fix this, edit the `redirect_uri` url parameter, which has had the login server hostname removed from it.

Change it from:

`redirect_uri=https%3A%2F%2Flogin%2Fcallback%2Fgoogle`

to

`redirect_uri=https%3A%2F%2Flogin.SYSTEM_DOMAIN%2Flogin%2Fcallback%2Fgoogle`
