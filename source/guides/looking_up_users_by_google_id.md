---
title: Looking up users by Google IDs
---

## The BUG

There is a general bug we have on the PaaS, where sometimes we list users in
the form of the external Google ID we got from an Google's SSO.

This is a difficult bug to fix and has been neglected for a while now...

This is annoying to us and our users, to establish who these people are...

## About SSO

When people use Google's SSO to log into PaaS, UAA does take a note of some of
their information. Among those, we get the email address and the person's name.

This essentially means that we can find out who the user is, by asking UAA for
more data.

## Working with an example

We had a need to email a specific user and inform them about their account being
suspended.

The only piece of information we had on this user, was their google ID which was
allocated to an organisation.

You can run:

```sh
cf curl /v2/organizations/ORG_GUID/users
```

Example output:

```json
{
  "total_results": 1,
  "total_pages": 1,
  "prev_url": null,
  "next_url": null,
  "resources": [
    {
      "metadata": {
        "guid": "USER_GUID"
      },
      "entity": {
        "username": "000000000000000000000"
      }
    }
  ]
}
```

This will give you the list of users. You can filter these resources by the
username you're trying to fish out.

Once you have found the user, obtain their `.metadata.guid`, you will be able to
fetch the data from UAA regarding that user.

UAA accepts the same token as the CF. The following command includes that token.

```sh
curl -H "Authorization: $(cf oauth-token)" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  https://uaa.london.cloud.service.gov.uk/Users/USER_GUID
```

Example output:

```json
{
  "id": "USER_GUID",
  "userName": "000000000000000000000",
  "name": {
    "familyName": "Jeff",
    "givenName": "Jefferson"
  },
  "emails": [
    {
      "value": "jeff.jefferson@example.com",
      "primary": false
    }
  ]
}
```
