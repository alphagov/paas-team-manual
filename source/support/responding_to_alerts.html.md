---
title: Responding to alerts
---

# Responding to alerts

Tips for responding to alerts when you are on support.

## Failed logins

In case of security incident, for example when alerted of a brute-force attack by Prometheus monitors,
it may help to look at UAA logs.

The access logs is on the UAA VMs in `/var/vcap/sys/log/uaa/localhost_access.log`.

All other logs are sent to [logit](https://logit.io/a/1c6b2316-16e2-4ca5-a3df-ff18631b0e74).
You must [Log into logit via Google](https://reliability-engineering.cloudapps.digital/manuals/logit-io-joiners.html)[external link] before you can access kibana.

* Scope to component: UAA
* filter by `@source.deployment: "prod"` or `@source.deployment: "prod-lon"` (depending on which deployment you are looking for)
* Look for strings like `UserNotFound`, `PrincipalAuthenticationFailure` or `UserAuthenticationFailure`
* `principal=XXX` will give you the username
* `origin=[1.2.3.4]` will give you the origin IP
* `UserAuthenticationSuccess` will give you the successful attempts
  * SSO authentication origin will show `sessionId=XXX`
  * UAA authentication origin will show `clientId=cf`

## CPU credits

These alerts tell us when an AWS instance that has burstable CPU performance
has exhausted its credits and is performing badly. This is an informational
alert that should help you understand why other alerts may be triggered at
the same time. For more information about CPU credits see:

- <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/t2-instances.html#t2-instances-cpu-credits>

## CDN broker healthy

The CDN broker has a healthcheck endpoint which confirms whether all of its
dependencies are working. If any are not working then the healthcheck
endpoint returns a 500 response code and response body containing the
errors.

Prometheus doesn't report the response body, which can make it hard to determine the actual problem. To
get this information you will need to SSH to any Cloud Foundry VM and query
the endpoint yourself:

```
bash# bosh-ssh api/0
…
api/00673a4a-b11f-410d-a037-34d56a3e2e71:~$ curl -i https://cdn-broker.<SYSTEM_DOMAIN>/healthcheck
HTTP/1.1 500 Internal Server Error
Content-Type: text/plain; charset=utf-8
Date: Fri, 02 Jun 2017 10:10:49 GMT
Content-Length: 52
Connection: keep-alive

cloudfoundry error: Could not get api /v2/info: EOF
```

## RDS Failures

Unfortunately, many types of `failure` event are not resolvable without getting in touch with AWS. In some circumstances you may be
able to restore an instance using [our point-in-time-restore
instructions](/guides/Restoring_the_CF_databases/).

When `failure` monitor triggers, before starting any further investigation and
work, we would like to notify our users of odd behaviour and let them know
we're working to solve this issue. Please see the [How to obtain organisation
managers](#how-to-obtain-organisation-managers) to learn who to contact.

For more information on the 8 types of `failure` event, see the [Amazon RDS
Event Categories and Event
Messages](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html#USER_Events.Messages).

## RDS Disk utilisation

Our tenants are likely to run low on storage on their RDS instances over time.
This is no reason to panic, but we would like to notify our users when this
happens.

Ideally, you should retrieve a GUID of an instance from the tags associated
with the metrics on the alert. Having that will help you establish the users to
contact, as they may wish to scale up their instance in response. Please see
the [How to obtain organisation managers](#how-to-obtain-organisation-managers)
to learn who to contact.

### How to obtain organisation managers

We've prepared a script to obtain organisation, space, instance name and the
list of managers connected to the instance you're after.

From `paas-cf` repository, run the following command:

```sh
./scripts/get-instance-details.sh "${RDS_INSTANCE_ID}"
```

## DDoS mitigation

When AWS detect a possible denial-of-service attack against PaaS, our in-hours
support gets an email. If you receive such an email, log into AWS Shield and look
at the details of what AWS have detected.

AWS automatically mitigate layer 3 and 4 attacks (i.e., junk network traffic.) You
should monitor PaaS's performance. Unless PaaS is degraded there is likely no need
to do more than monitor this.

AWS do not automatically mitigate layer 7 attacks (i.e., mass HTTP requests.) These
are not always malicious: large submissions to GOV.UK Notify can run at 900rps, and
AWS detects that as a request flood. Reviewing the details in AWS Shield can help
identify whether there is a real attack. You can create new AWS WAF rules to combat
this traffic.

If facing a large, complex or uncertain attack, contact the AWS DDoS Response Team
(DRT): https://docs.aws.amazon.com/waf/latest/developerguide/ddos-responding.html.

## API Latency

Last time we received an alert for API latency, it was a UAA bug that caused
instances to leak memory. It also resulted in high CPU usage and the quickest
solution to restoring the platform was to restart both instances one after the
other.

```sh
cd ${PAAS_BOOTSTRAP_DIR}
DEPLOY_ENV=prod make prod bosh-cli
bosh restart uaa # You may want/need to target an instance, e.g. uaa/23888ebf-2dd3-4afe-b370-51705403d423
```

There may be different reasons for the latency to drop down on any of the VMs.
We found out the issue by logging into the VM itself and dig through the logs.

```sh
cd ${PAAS_BOOTSTRAP_DIR}
DEPLOY_ENV=prod make prod bosh-cli
bosh ssh uaa/23888ebf-2dd3-4afe-b370-51705403d423
tail -1000 /var/vcap/sys/log/uaa/uaa.log
```

In the case of the UAA latency incident, it turned out that the CF Upgrade we
did previously, contained a UAA release introducing the memory leak. The
solution was to upgrade UAA release on its own.

Read more in the
[UAA Downtime investigation](https://www.pivotaltracker.com/n/projects/1275640/stories/151808174)
story.

## Intermittent ELB failures

Users have previously experienced intermittent request timeouts and errors when
accessing their apps. During a particular incident, we believe that requests
timed out due to ELB node failures.

We publish two metrics:

1. `aws.elb.unhealthy_node_count` - number of IPs that failed to respond to an HTTP request
1. `aws.elb.healthy_node_count`   - number of IPs that responded as expected

Details of the monitoring approach can be found in
[the README for our monitoring application](https://github.com/alphagov/paas-cf/blob/master/tools/metrics/README.md).

We have been advised by AWS that if we believe we are experiencing an issue
with one or more ELB nodes that we should raise a "high priority" support
ticket with them.

To obtain the IP address of the failing node(s), you should inspect the logs of
the paas-metrics app. This is deployed to the 'monitoring' space of the 'admin'
org. You should see logs such as:

```
2017-12-01T14:14:09.68+0000 [APP/PROC/WEB/0] OUT
{
    "timestamp":"1512137649.686135292",
    "source":"metrics",
    "message":"metrics.elb-node-failure",
    "log_level":1,
    "data":{
        "addr":"52.31.169.122:443",        <-- this is the ELB node IP
        "err":"bad error happened!",
        "start":"2017-12-01T14:14:09.679602987Z",
        "stop":"2017-12-01T14:14:09.679602987Z"
    }
}
```

Read more in the
[Incident Report](https://docs.google.com/document/d/1XUH42lgt86q2XGZY1uosb0M44vtnpeyREDJlyfxs72w/edit#heading=h.bac2cwm6xa89).

## Invalid Certificates

[paas-metrics](https://github.com/alphagov/paas-cf/blob/master/tools/metrics/README.md)
exposes two metrics relating to certificate validity:

* `tls.certificates.validity` - number of days before expiry of the platform's public-facing certificates
* `cdn.tls.certificates.validity` - number of days before expiry of certificates for CloudFront aliases (tenants' custom domain names). This is for all CDNs, not just those created by the broker.

If the endpoints are misconfigured or the certificate is considered invalid for
some other reason the value will fall to `0` and alert as expired/invalid.

If the platform certificates are due to expire, check AWS Certificate Manager for the validation settings, as they should
validate automatically via DNS. 

For CDN certificates start with AWS Certificate Manager in the `us-east-1` region to see why the certificate didn't get renewed. The most common cause is tenants removing the DNS records required for valdiation. Use `dig -t CNAME` to check if they're still set.

If you are seeing `NO_DATA` errors for this monitor then there may be a more
fundimental connectivity issue to the reported endpoint.

The `cf logs` output of the paas-metrics app may contain additional
information. This is deployed to the 'monitoring' space of the 'admin' org.

## Cloud Foundry internal certificates

We generate several certificates for Cloud Foundry which need to be rotated regularly (most of them have a 1 year expiry).

We have a [Concourse job](https://deployer.cloud.service.gov.uk/teams/main/pipelines/create-cloudfoundry/jobs/check-certificates/builds/latest) which checks if we have certificates expiring in less than 30 days.

If you need to rotate a certificate before it would otherwise be rotated automatically, you can [perform step 1](https://github.com/pivotal-cf/credhub-release/blob/master/docs/ca-rotation.md#step-1-regenerate) of the Credhub CA cert rotation, and then allow the pipeline to take over.

## Trusted Advisor Warnings

If you see a warning from Trusted Advisor it should be addressed.

* IAM: Access keys should be rotated every 90 days, you should chase the owner
  of the offending key, delete the key or you can use [this script](https://github.com/keymon/aws_key_management/blob/master/rotate_access_keys.sh)
  to help with rotating keys.

The following Trusted Advisor checks cause expected warnings:

* S3 Bucket Permission's for `gds-paas-*-cdn-broker-challenge` are required to be publicly accesible so it is safe to mark these as excluded.
* S3 Bucket Permission's for `gds-paas-*-ci-releases` are required to be publicly accesible so it is safe to mark these as excluded.
* S3 Bucket Permission's for `gds-paas-*-ci-releases-blobs` are required to be publicly accesible so it is safe to mark these as excluded.
* ELB Listener Security for `*-ssh-proxy`: This ELB is in TCP mode and so this warning is expected
* Security Group - Specified Ports Unrestricted for `*-sshproxy`: We intentionally allow port 2222 for `cf ssh` access so it is safe to mark this as excluded.

## Gorouter high latency alerts

If you see an alert for gorouter latency being high;

* Check with the team if we have any known load testing occuring either by the team or by a tenant
* [Log into logit via Google](https://reliability-engineering.cloudapps.digital/manuals/logit-io-joiners.html)[external link]
* Visit [kibana](https://kibana.logit.io/s/665ca355-efc3-46a2-96cf-21d31a5305bb/app/kibana#/) and filter by `@source.component: gorouter` and `@source.deployment: "prod"` or `@source.deployment: "prod-lon"` (depending on which deployment you are looking for) then add in `gorouter.host` to the table, this will show you which hosts are being most used currently
* Contact the team who own the service to see if they are aware of anything happening

As this is the first monitor of this type please investigate the gorouters to discover the issue they are encountering. We have previously seen high resource usage (CPU and Memory) these should be checked in the first case.

## Diego cell ephemeral disk usage near full

To prevent a tenant-visible issue in the short term, it's probably a good idea to recreate the cell in bosh:

```
cd ${PAAS_BOOTSTRAP_DIR}
DEPLOY_ENV=prod make prod bosh-cli
bosh restart diego-cell/123
```

In the long term, this should be investigated because it Shouldn't Happen. The grootfs
garbage collector should keep disk space under control, so perhaps this is a sign that
it isn't working properly.

The [last time this happened](https://docs.google.com/document/d/1727mhApwfZdDafc0qPzPaJg_000JvzqfPCfFCKhLPqY/edit?ts=60f0422c#)
we weren't quick enough investigating it and the logs fell out of logit, preventing us
from diagnosing the true cause. So don't make the same mistake.
