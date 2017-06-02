Cloud Foundry's account management is mostly controlled by [UAA][]

[UAA]: https://github.com/cloudfoundry/uaa

## Interacting with UAA

### Install

You can access the [uaac][] command line utility from the [scripts directory
of alphagov/paas-cf][scripts]. Using [Bundler][] will ensure that you have
the appropriate version.

[uaac]: https://github.com/cloudfoundry/cf-uaac
[scripts]: https://github.com/alphagov/paas-cf/tree/master/scripts
[Bundler]: http://bundler.io/

To install:
```
➜  paas-cf git:(master) ✗ cd scripts
➜  scripts git:(master) ✗ bundle install
…
```

To confirm that it works:
```
➜  scripts git:(master) ✗ bundle exec uaac help

UAA Command Line Interface
…
```

### Log in

To target an environment:

    bundle exec uaac target https://login.<SYSTEM_DOMAIN>

You can log in with a normal CF account. You should use either:

- for persistent environments where we have SSO admin users:

        bundle exec uaac token sso get cf -s ""

- for development environments where we have a single CF admin account:

        bundle exec uaac token owner get cf admin -s ""

Please avoid using `uaa_admin_client_secret` and `uaa_admin_password`
because it gives you more permissions than necessary and means that we can't
track activity in persistent environments.

There is a command to refresh your access token when it expires, but it is
worth re-authenticating instead to ensure that you are still targeting the
environment that you expect.

## Finding a user account

If you know the exact username of the account:

    bundle exec uaac user get <EMAIL>

If you only know part of the username:

    bundle exec uaac users 'username co "<NAME>"'

## Locking a user account

Sometimes it might be necessary to lock certain users. For example when we find out they have left GDS or don't have any more project to work on PaaS. CF has a facility to prevent users from logging in, while still preserving the user account with all their access rights and org membership. We do this as a first step in removing the user account. We then ask for confirmation from org managers (or managers of org managers in case we are removing an org manager) and only after confirmation finally remove the account completely (`cf delete-user`).

In UAA terms, 'locking' the user/user account means the account is blocked by UAA after a number of unsuccessful attempts to authenticate. There is only a way to 'unlock' the account, but not lock. However, you can _disable_ the user, which means they can't log in:

1. Get the user ID from [finding a user account](#finding-a-user-account).
1. Get properties of user in json form: `bundle exec uaac curl /Users/<user_id> >u.json`
1. Clean up the `u.json` file and keep only json properties of user.
1. Edit user properties json - change `active` to `false`
1. Update user:  `bundle exec uaac curl /Users/<user_id> -H 'content-type: application/json' -X PUT -H 'If-Match: *' -d "$(<u.json)"`
1. Verify changes applied by checking state: `bundle exec uaac user get <name@digital.cabinet-office.gov.uk>`

## Finding out org membership

In order to notify the org manager of a given user, we need to find out who that would be. UAA does not know which org/space user belongs to. This information is only available to cloud controller: `cf curl /v2/users/<uaa_user_id>/summary`

The user summary contains all orgs and spaces they are member of. It also contains the UAA ID of managers of these. To get user name from UAA id, simply: `bundle exec uaac curl /Users/<uaa_user_id> | grep userName`

## Notifying the org manager

Send an email from support email address: `gov-uk-paas-support@digital.cabinet-office.gov.uk`. Example email:

```
Hi <org manager 1st name>,

We have noticed that <user name of disabled account> was inactive <describe how we found out, e.g. when we tried to send him email and it got bounced>. We wondered if perhaps this person has left GDS. We have noticed this user still has an account in `<org name>` organization and `<space name(s)>` space. We have disabled this user for now.

Can you please confirm if we can remove the user entirely, or instead if the user is still expected to have access to the PaaS?


Thanks,
PaaS for Government
```

When they respond support can follow up with user deletion, or instead enable the user account again if it is to be actively used.
