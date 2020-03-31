# Notifying tenants

Every now and then, we need to let our tenants know that something has happened or will happen on the platform. For example, letting teams know about security fixes, CF/stemcell/buildpack upgrades, new features and incidents.

Depending on what it is we want to tell users, we have three different channels for sending these notifications:

* incident alerts and reports are sent using [our Statuspage account](https://manage.statuspage.io/pages/h4wt7brwsqr0)
* changes and fixes are sent via the [technical emails channel](#sending-critical-technical-emails)
* upgrades and new feature announcements are sent using the [GOV.UK PaaS Announce Google group](https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/?hl=en#!forum/gov-uk-paas-announce)

## Sending incident alerts and updates

Follow the guidance in [this section](/incident_management/incident_process/#incident-comms-lead) of the team manual if you're managing incident comms and you need to send alerts and updates to tenants.

## Sending platform change and new feature announcements

### Changes, upgrades and fixes

Write a draft email and share it [here.](https://drive.google.com/drive/folders/1M5G-joG3tORfJ5kXj368Ib8rEKau2vFq)

Get a Product Manager to proof-read and add any 'product-y' elements - we want to make sure our notifications are consistent and meet the GDS style guidelines. If the email is time-sensitive and there are no Product Managers around, get another member of the team to proof-read the email before it's sent.

### Announcing new features

These announcements are our chance to showcase how we're developing GOV.UK PaaS and will be written and sent by the product managers. Product Managers may ask the team member who worked on the story to provide some technical details that can be inclued in the email.


### Sending marketing emails to tenants

Use the [google group interface] to send the email.

* Click on `New topic`
* In `By` select: Post on behalf of GOV.UK PaaS announce
* The `Subject` should help identify immediately the purpose of the email.
Ex: "Incident with..."
* In `Type of post` select: "Make an announcement" to emphasize this is
one way communication
* Body: paste the content of the reviewed draft. You may have to adjust formatting.

## Sending (critical) technical emails
Essential information and actions tenants need to carry out in order to ensure their service remains live.

1. Write email body copy to tenants to populate the email

1. Your email **must** contain the following header

    ```
    Dear GOV.UK PaaS tenant,
	  
    We (GOV.UK Platform as a Service - PaaS) are contacting you to inform you of 
    [BODY COPY].
    ```

1. Your email **must** contain the following footer
	  
    ```
    This communication complies with out data protection policy.
	  
    As we outline in our Privacy Notice: 
	  
    In order to make GOV.UK PaaS secure and available we need to collect, process and store personal data from tenants. We store the data you provide to:
    get in contact to reply to your queries
    make your user account function correctly
    manage your user account
    send you updates and notices
    If you have any questions, please contact gov-uk-paas-support@digital.cabinet-office.gov.uk
	  
    Kind regards,
    The GOV.UK PaaS Team
    ```
	
1. Get tenant email addresses
	* Tenant email addresses can be pulled from Cloud Foundry. There is a Make target for this, which produces a CSV that can be uploaded to GOV.UK Notify

		```
		make prod show-tenant-comms-addresses > addresses_prod.csv
		make prod-lon show-tenant-comms-addresses > addresses_prod-lon.csv
		```
		
	 	If the information being sent is critical, and not carrying out the required action will result in service downtime
		the `CRITICAL=true` flag can be passed. This will include org managers, org auditors and space 
		managers and auditors in the output.
		
        If the information being sent is not suitable for developers or they are unlikely to have the information required
        the `MANAGEMENT=true` flag can be passed. This will include org managers, org auditors and billing managers in the output.
		
		By default, only space developers are included.
		
1. Create template to GOV.UK Notify
	1. Login to [GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in). If you do not have login details speak to a senior member of the team.
    
	1. Create a new template in GOV.UK Notify, with the body of the email.
    
1. Navigate to where you stored the CSV files, and import it.
    
1. Click on 'Send X emails’, where X should be the number of people to contact.
	
1. Send emails to the contents of both CSV files

### CF upgrade email template

<a id="cf-upgrade"></a>

Subject (ex): GOV.UK PaaS - Cloud Foundry changes - 17th March 2017

The body should contain:

 - Changes and bugfixes to highlight and new features enabled.
 - Downtime or service impact if any
 - Summary of buildpack changes.

### CF buildpack emails

We generate our buildpack notification emails using the (semi-)automated
process described in [the documentation about upgrading
buildpacks](/guides/upgrading_CF,_bosh_and_stemcells/#buildpacks).

**NB Incident comms email templates are saved in Statuspage.**

[google group interface]: https://groups.google.com/a/digital.cabinet-office.gov.uk/forum/?hl=en#!forum/gov-uk-paas-announce
