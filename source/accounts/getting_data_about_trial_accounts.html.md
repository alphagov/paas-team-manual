# Getting data about trial accounts

This guide is for the technical work involved in managing trial and abandoned
orgs. We are now enforcing a 3 month trial policy in order to reduce costs. We
look for orgs which are older than 75 days because we want to notify them just
prior to expiry.

## How to get the data

1. Log into Prod (Ireland)
1. Run `paas-cf/scripts/org-usage-report.rb`
1. Do the same for Prod (London)

## Expiring Orgs

These are orgs that have are close to, or have gone over, their trial period.

Our process is still being refined. This work should be carried out as part of
a Pivotal story, so for now it should be fine to attach the HTML/PDF
output to a comment in the story.

### To contact the org managers

1. Login to [Notify](https://www.notifications.service.gov.uk/sign-in). If you
   do not have login details speak to a senior member of the team.
1. Select `Templates`
1. Select `Convert trial period to paid org`
1. Select `Send`
1. Select `Upload a list of email addresses`
1. Select `Choose a file`
1. Choose `Desktop/expiring-orgs.csv`
1. Select `Send X emails`, where X should be the number of people to contact.

We should then mark the story as blocked until seven days have passed. Once
this time has passed we can upgrade the quota of the orgs to the next highest
non-trial quota.

## Abandoned orgs

These are orgs created over 75 days ago, with no users or no apps.

### To contact the org managers

**At this point the data should be checked with the PM team before proceeding**

1. Login to [Notify](https://www.notifications.service.gov.uk/sign-in). If you
   do not have login details speak to a senior member of the team.
1. Select `Templates`
1. Select `Unused organisation removal notice`
1. Select `Send`
1. Select `Upload a list of email addresses`
1. Select `Choose a file`
1. Choose `Desktop/abandoned-orgs.csv`
1. Select `Send X emails`, where X should be the number of people to contact.

We should then mark the story as blocked until seven days have passed. Once
this time has passed we can delete the orgs and notify them of deletion. For
notification of deletion, follow the steps above but using the template called
`Unused organisation removed`.
