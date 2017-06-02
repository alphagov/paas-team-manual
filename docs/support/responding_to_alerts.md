Tips for responding to alerts when you are on support.

## Failed logins

In case of security incident, for example when alerted of a brute-force attack by datadog monitors,
it may help to look at UAA logs.

The access logs is on the UAA VMs in `/var/vcap/sys/log/uaa/localhost_access.log`.

All other logs are sent to [logsearch](https://logsearch.cloud.service.gov.uk):

* Scope to component: UAA
* Look for strings like `UserNotFound`, `PrincipalAuthenticationFailure` or `UserAuthenticationFailure`
* `principal=XXX` will give you the username
* `origin=[1.2.3.4]` will give you the origin IP
* `UserAuthenticationSuccess` will give you the successful attempts
  * Google authentication origin will show `sessionId=XXX`
  * non Google authentication origin will show `clientId=cf`

## CPU credits

These alerts tell us when an AWS instance that has burstable CPU performance
has exhausted its credits and is performing badly. This is an informational
alert that should help you understand why other alerts may be triggered at
the same time. For more information about CPU credits see:

- <http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/t2-instances.html#t2-instances-cpu-credits>

## BTRFS processes

Sporadically concourse will fail due to an undiagnosed problem. When this occurs hundreds of `btrfs qgroup show` processes will continuously spawn and cause the system load to spike until concourse grinds to a halt. At this point the only thing that can be done is to shut down concourse and clear out the volumes from both the disk and the concourse database.

We have automated this process, all you need to do is run `make $AWS_ACCOUNT shake_concourse_volumes` and the instance should recover. This is also known as "shaking concourse".

## CDN broker healthy

The CDN broker has a healthcheck endpoint which confirms whether all of its
dependencies are working. If any are not working then the healthcheck
endpoint returns a 500 response code and response body containing the
errors.

The version of the DataDog agent that we currently use doesn't report the
response body, which can make it hard to determine the actual problem. To
get this information you will need to SSH to any Cloud Foundry VM and query
the endpoint yourself:

```
/tmp/build/04dcec6b # bosh ssh api/0
…
api/00673a4a-b11f-410d-a037-34d56a3e2e71:~$ curl -i https://cdn-broker.<SYSTEM_DOMAIN>/healthcheck
HTTP/1.1 500 Internal Server Error
Content-Type: text/plain; charset=utf-8
Date: Fri, 02 Jun 2017 10:10:49 GMT
Content-Length: 52
Connection: keep-alive

cloudfoundry error: Could not get api /v2/info: EOF
```
