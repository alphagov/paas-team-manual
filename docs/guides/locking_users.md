Sometimes it might be necessary to lock certain users. E.g. when we find out they left GDS or don't have any more project to work on PaaS. CF has facility to prevent users logging in, while still preserving user account with all theri access rights and org membership. We do this as a 1st step in removing user account. We then ask for confirmation from org managers (or managers of org managers in case we are removing org manager) and only after confirmation finally remove the account completely (`cf delete-user`). 

### Locking the user account
In UAA terms, 'locking' the user/user account means that account is blocked by UAA after configured unsuccessful attempts to authenticate. There is only a way to 'unlock' the account, but not lock. However, you can _disable_ the user, which means they can't log in:
1. Get `uaac`. e.g. `gem install cf-uaac`. Currently, 3.5.0 is the latest version.
2. "Log-in" - get the token for the admin _client_: `uaac token client get admin`. You will have to provide admin client secret as password.
3. Get the user: `uaac user get <name@digital.cabinet-office.gov.uk>`. Note the user ID.
4. Get properties of user in json form: `uaac curl /Users/<user_id> >u.json`
5. Clean up the `u.json` file and keep only json properties of user.
5. Edit user properties json - change active to false
6. Update user:  `uaac curl /Users/<user_id> -H 'content-type: application/json' -X PUT -H 'If-Match: *' -d "$(<u.json)"`
7. Verify changes applied by checking state: `uaac user get <name@digital.cabinet-office.gov.uk>`

UAA API is described in detail here: https://docs.cloudfoundry.org/api/uaa/
Currently uaac only supports updating these user options, so if you want to change anything else, you need to use API directly, via `uaac curl`:
```
  user update [name]               Update a user account with specified options
                                   --given_name <name>
                                   --family_name <name>
                                   --emails <addresses>
                                   --phones <phone_numbers>
                                   --del_attrs <attr_names>, list of attributes to delete
```

### Finding out org membership
In order to notify org manager of the given user, we need to find out who that would be. UAA does not know which org/space user belongs to. This information is only available to cloud controller:`cf curl /v2/users/<uaa_user_id>/summary`

User summary contains all orgs and spaces they are member of. It also contains UAA ID of managers of these. To get user name from UAA id, simply `uaac curl /Users/<uaa_user_id>| grep userName`

### Notifying the org manager
Send email [from support email address](link to how to configure this - we have it here in the docs). When they respond, a new support case will be created and support can follow on (e.g. with user deletion, or instead enable the user account again if it is to be actively used). This is approximate email template to send:

```
Hi <org manager 1st name>,

we have noticed that <user name of disabled account> was inactive <describe how we found out, e.g. when we tried to send him email and got bounce>. We wondered if perhaps this person left GDS. We have noticed this user still has account in `<org name>` organization and `<space name(s)>` space. We have disabled this user for now.

Can you please confirm if we can remove the user entirely, or instead if the user is still expected to have access to the paas?


Thanks,
PaaS for Government
```

