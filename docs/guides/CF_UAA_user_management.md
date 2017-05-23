## Locking a user account

Sometimes it might be necessary to lock certain users. For example when we find out they have left GDS or don't have any more project to work on PaaS. CF has a facility to prevent users from logging in, while still preserving the user account with all their access rights and org membership. We do this as a first step in removing the user account. We then ask for confirmation from org managers (or managers of org managers in case we are removing an org manager) and only after confirmation finally remove the account completely (`cf delete-user`).

In UAA terms, 'locking' the user/user account means the account is blocked by UAA after a number of unsuccessful attempts to authenticate. There is only a way to 'unlock' the account, but not lock. However, you can _disable_ the user, which means they can't log in:

1. Get `uaac` command line via `gem install cf-uaac`
1. Login with the admin _client_: `uaac token client get admin`. You will have to provide admin client secret as password.
1. Get the user: `uaac user get <name@digital.cabinet-office.gov.uk>`. Note the user ID.
1. Get properties of user in json form: `uaac curl /Users/<user_id> >u.json`
1. Clean up the `u.json` file and keep only json properties of user.
1. Edit user properties json - change `active` to `false`
1. Update user:  `uaac curl /Users/<user_id> -H 'content-type: application/json' -X PUT -H 'If-Match: *' -d "$(<u.json)"`
1. Verify changes applied by checking state: `uaac user get <name@digital.cabinet-office.gov.uk>`

## Finding out org membership

In order to notify the org manager of a given user, we need to find out who that would be. UAA does not know which org/space user belongs to. This information is only available to cloud controller: `cf curl /v2/users/<uaa_user_id>/summary`

The user summary contains all orgs and spaces they are member of. It also contains the UAA ID of managers of these. To get user name from UAA id, simply: `uaac curl /Users/<uaa_user_id> | grep userName`

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
