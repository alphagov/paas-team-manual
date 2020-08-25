# PagerDuty

The team uses [PagerDuty](https://www.pagerduty.com/) to be notified of platform issues.

## Account

Our team account is called [gds-paas](https://governmentdigitalservice.pagerduty.com/).

The account owner sets up individual users who authenticate via username (email) / password. All users are administrators.

Users are invited to add their telephone number(s) to their profile to be able to receive the notifications. Only high-urgency notification rules are used.

There is also a team user called "PaaS team" that is used to send email notifications to the team. Its credentials are stored in the credentials repository.

## Schedules

Each schedule represents a set of times when we want to be notified and the list of people that may be notified, one at a time.

We have 3 schedules:

* In hours support
* Out of hours support
* Out of hours escalation

## Escalation policies

We have created 2 escalation policies. Depending on the gravity of the incident, we may want to be alerted only during office hours, or all the time including out of hours.

### In hours only

This creates a single notification for who is on call at that moment. If the alert happens outside of office hours, it falls through to the team email and creates an incident that can be checked the next day.

### 24x7

This policy uses the in hours schedule first. When out of hours, the alert falls through immediately to the out of hours schedule. Failing that, the escalation schedule is used.
The team email notification is added at the end as well to cover any potential gap in the schedules.

## Services

We integrate with Pingdom and Prometheus. For each integration we create one in hours service that uses the in hours only escalation policy, and one 24x7 service that uses the 24x7 escalation policy.

A special service called Emergency email is dedicated to urgent platform issues impacting tenants. Sending an email to it triggers a ZenDesk ticket to be created and an incident in PagerDuty. The incident is attached to the *24x7* escalation policy.

For all services, incidents are not auto resolved and only high-urgency notification rules are used.

## Manage rota

### Add/remove from rota

Edit the schedule and add the user to the list of users. Be careful as it may change the other users' schedule. Don't forget to click `Save changes`.

### Temporary change

Overrides can be used to temporary replace a default user from the rota with another user. The original rota remains unchanged and PagerDuty reverts to it at the end of the override.

To schedule an override, click on `Schedule an override` on the right handside. It will then be listed under `Upcoming overrides` on the right handside and can be removed from there.

### Swap

When a user has planned vacation for example, it is better to swap their shift with another user. If user1 wants to swap a shift with user2, create a user2 override for user1's shift, and a user1 override for user2's shift. The 2 shift should be exactly the same duration.

Tip: click on the shift you want to override and select `Schedule an override` from the drop-down menu.

## Respond to incidents

As soon as a notification is received by the user, they should acknowledge the incident. It can be done directly on the phone or via the incidents web page.

If the incident is not resolved it will return to Triggered state after 30min and will alert the same user again.

When the incident is resolved, add a brief note to log what happened.
