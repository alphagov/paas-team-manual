# Notifying tenants

Every now and then, we need to let our tenants know something has happened or will happen on the platform.

For example:

* security problems and fixes
* upgrades of CF, stemcells, buildpacks
* incident reports

At some point in the future, we will create an automated way of doing this, probably using [Notify](https://www.notifications.service.gov.uk/).

We will probably also introduce better channels of communication - perhaps a status page, user forum, or explicit mailing list.

Until then, our manual process is documented here.

## Email draft

Write the email you want to send.

We don't have formal templates at the moment, but we have started to develop something approaching a 'house style' by example.

Previous emails are stored in [Google Docs](https://drive.google.com/drive/folders/0Bw4pWpR0IbJfWGFEMVBBZlFsSDQ)

Once you have your draft, get someone else on the team to proofread it.

## Tenant addresses

Find the list of tenant email addresses to send to by querying the platform.

We don't yet have a better list of who should be notified than the list of CF users.

Log in to the `prod` CF, then

```
for org in `cf orgs | tail -n+4`; do
  cf target -o $org >/dev/null;
  for space in `cf spaces 2>&1 | tail -n+4`; do
    cf space-users $org $space;
  done;
done | grep '@' | sort | uniq
```

## Send the email

**IMPORTANT: Remember to put the recipient list in `bcc:`!**

We send the email from any team member's `gov.uk` GMail account.

We use support email address as a non-alias to send from. To configure that for your account, follow these instructions:

[Setting up an alternative 'Send from' address](https://support.google.com/mail/answer/22370?hl=en)

[Difference between alias and non-alias](https://support.google.com/a/answer/1710338?ctx=gmail&hl=en-GB&authuser=0&rd=1)

*This bears repeating: use `bcc:`. No, not that one, that's `to:`. That's `cc:`. You got it, `bcc:`!*
