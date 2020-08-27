# User management

## Creating new orgs and users

We encourage tenants to invite and manage their own users via the paas-admin interface.

If you need to create a new org and invite the initial org manager(s) you can do so using the `GOV.UK PaaS Admin > Platform Admin > Create new organisation` page. You should be creating new orgs in the London region by default.

## Interacting with UAA

Cloud Foundry's account management is mostly controlled by [UAA][]

[UAA]: https://github.com/cloudfoundry/uaa

### Install

You can access the [uaac][] command line utility from
[alphagov/paas-cf][paas-cf]. Using [Bundler][] will ensure that you have the
appropriate version.

[uaac]: https://github.com/cloudfoundry/cf-uaac
[paas-cf]: https://github.com/alphagov/paas-cf
[Bundler]: http://bundler.io/

To install:

```
➜  paas-cf git:(master) ✗ bundle install
…
```

To confirm that it works:

```
➜  paas-cf git:(master) ✗ bundle exec uaac help

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

The above two commands will only work for users who are not using single-sign
on, PaaSmin has a page for getting diagnostic information about a user.
Navigate to one of the following, depending on the region:

- [https://admin.cloud.service.gov.uk/users/person@domain.com](https://admin.cloud.service.gov.uk/users/person@domain.com)
- [https://admin.london.cloud.service.gov.uk/users/person@domain.com](https://admin.london.cloud.service.gov.uk/users/person@domain.com)

The endpoint also works for UAA GUIDs:

- [https://admin.cloud.service.gov.uk/users/aaaaaaaa-bbbb-cccc-dddd-111122223333](https://admin.cloud.service.gov.uk/users/aaaaaaaa-bbbb-cccc-dddd-111122223333)
- [https://admin.london.cloud.service.gov.uk/users/aaaaaaaa-bbbb-cccc-dddd-111122223333](https://admin.london.cloud.service.gov.uk/users/aaaaaaaa-bbbb-cccc-dddd-111122223333)

## Locking a user account

Sometimes it might be necessary to lock certain user accounts. For example, when we find out they have left GDS or are no longer working on the PaaS team. 

Cloud Foundry has a facility to prevent users from logging in while still preserving the user account with all their access rights and org membership. We use this facility as a first step in removing the user account and then:

* ask for confirmation from org managers (or managers of org managers if we are removing an org manager)
* remove the account completely (`cf delete-user`) once we have received confirmation

From [alphagov/paas-cf](https://github.com/alphagov/paas-cf):

```
bundle install
cd scripts
TARGET=$(cf curl /v2/info | jq -r .token_endpoint) \
  TOKEN=$(cf oauth-token) \
  bundle exec ./uaa_lock_user.rb <USERNAME>
```

## Finding out org membership

In order to notify the org manager of a given user, we need to find out who that would be. UAA does not know which org/space user belongs to. This information is only available to cloud controller: `cf curl /v2/users/<uaa_user_id>/summary`

The user summary contains all orgs and spaces they are member of. It also contains the UAA ID of managers of these. To get user name from UAA id, enter: `bundle exec uaac curl /Users/<uaa_user_id> | grep userName`

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

## Global Auditor role

We use the [Global Auditor role][] for team members of our team that need to
query or report on usage but don't have production access.

[Global Auditor role]: https://docs.cloudfoundry.org/concepts/roles.html#roles-and-permissions

To add someone:

```
bundle exec uaac member add cloud_controller.global_auditor <EMAIL>
```

To remove someone:

```
bundle exec uaac member delete cloud_controller.global_auditor <EMAIL>
```

To see the current members:

```
(set -o pipefail \
  && bundle exec uaac group get cloud_controller.global_auditor \
  | awk '$1 == "value:" {print $2}' \
  | xargs -n1 -I{} bundle exec uaac users "id eq \"{}\"" -a username)
```
