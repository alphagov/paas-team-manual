# Notifying tenants

Every now and then, we need to let our tenants know something has happened or will happen on the platform. For example:

* security problems and fixes
* upgrades of CF, stemcells, buildpacks
* incident reports
* ongoing incidents

## Email draft

Write a draft email using a [template](#templates) as required and share it for example in [Google Docs](https://drive.google.com/drive/folders/0Bw4pWpR0IbJfWGFEMVBBZlFsSDQ).

Then get someone else on the team to proofread it.

## Send the email

Use the [google group interface](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/?hl=en#!forum/gov-uk-paas-announce) to send the email.

* Click on `New topic`
* In `By` select: Post on behalf of GOV.UK PaaS announce
* The `Subject` should help identify immediately the purpose of the email.
Ex: "Incident with..."
* In `Type of post` select: "Make an announcement" to emphasize this is
one way communication
* Body: paste the content of the reviewed draft. You may have to adjust formatting.

## Templates

In general you can follow this basic format:

* What are we doing
* Why are we doing it
* Action the user needs to take

The equivalent for incidents would be:

* What is happening (that we know)
* What we are doing
* Any action the user should take (or things we know they *shouldn't* do)

### We're having an incident

```
Hello,

We are aware of and investigating a problem with GOV.UK PaaS.
[Summarise problem and scale]
[Summarise consequences for tenants AND end users]

We will update you as soon as we know more information. In the meantime,
if you do need any help, you can contact us via our help desk:
gov-uk-paas-support@digital.cabinet-office.gov.uk.

Apologies for the inconvenience.

Regards,
GOV.UK PaaS
```

### Incident update

```
Hello,

We are actively working on the issue.
[Summarise problem and scale]
[Detail consequences for tenants AND end users]

[Explain what has been done so far to investigate]
[Mention any support case opened with our providers (AWS, DNS...)]

[Mention any action the user should take]
[Mention things we know they should not do]
[Explain workarounds for broken things]

We will update you as soon as we know more information. In the meantime,
if you do need any help, you can contact us via our help desk:
gov-uk-paas-support@digital.cabinet-office.gov.uk.

Apologies for the inconvenience.

Regards,
GOV.UK PaaS
```

### Incident over


```
Hello,

We are letting you know that there were problems with GOV.UK PaaS [insert time period].

[Summarise problem and how we fixed it]
[Detail consequences for tenants AND end users]

In the coming days we will publish an incident report detailing the
timeline of events, root cause, lessons learned and actions we will be taking to improve robustness of the platform.

If you notice any issue, you can always contact us via our help desk:
gov-uk-paas-support@digital.cabinet-office.gov.uk.

Apologies for the inconvenience.

Regards,
GOV.UK PaaS
```
