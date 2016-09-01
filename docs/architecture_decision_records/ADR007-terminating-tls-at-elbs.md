
Context
=======

We needed to decide where to terminate TLS connections for public and tenant
facing endpoints and how to manage the corresponding private keys.

We had previously decided to only support HTTPS to both deployed applications
and Cloud Foundry endpoints.

At the time of writing there were 4 endpoints to consider:

- Deployed applications (gorouter). Accessed by the public.
- CF API. Accessed by tenants.
- UAA. Accessed by tenants.
- Loggregator. Accessed by tenants.
- SSH proxy. In theory accessed by tenants, but not working in our environment.

We had an existing credentials store suitable for storing the private keys at
rest. Only a small number of engineers within the team can access; the same
ones that can make IAM changes using our account-wide terraform config.

Placing ELBs in front of public-facing services is an architectural pattern
advised by Amazon [in order to reduce attack 
surface](https://d0.awsstatic.com/whitepapers/DDoS_White_Paper_June2015.pdf).
Specifically they advise that it helps withstand volumetric Denial of Service
attacks; the ELB handles TCP connections and therefore the responsibility for
handling DDOS at Layer 4 and below resides with the ELB team.

We did a spike, where we attempted to place everything public-facing or
tenant-facing behind ELBs. We found that:

- In HTTP mode the ELBs do not support web sockets. This is known to break
  loggregator, which relies on them for log streaming. It would also prevent
  tenants from using web sockets within their applications.
- When the ELB is in TCP mode, we have no way of communicating the client IP
  address to the downstream service. Practical consequences of this would be
  that tenants would be unable to see in their logs who is using their service or
  do any access control based on client IP address.

In attempting to solve the second problem, we explored some options:

- ELB has support for the [Proxy
  Protocol](http://www.haproxy.org/download/1.5/doc/proxy-protocol.txt), but
  unfortunately none of the downstream services, such as gorouter, support it. It
  seemed simple to add support to gorouter.
- We could introduce another intermediary proxy such as HAProxy, which
  understands the proxy protocol and adds or appends to an `X-Forwarded-For`
  header with the client IP address as provided via the proxy protocol.

Decision
========

We decided to:

- use the ELB to terminate TLS
- use the ELB in TCP mode
- submit proxy protocol support to gorouter
- use S3 logging to ensure we have the IP addresses of clients using the CF
  endpoint

Status
======

Accepted

Consequences
============

- We played a [spike to investigate setting X-Forwarded-For
  correctly](https://www.pivotaltracker.com/projects/1275640/stories/116619465)
  which produced an [upstream PR to add proxy protocol support to
  gorouter](https://github.com/cloudfoundry/gorouter/pull/126) and [another to introduce
  X-Forwarded-Proto headers](https://github.com/cloudfoundry/gorouter/pull/127)
- As an interim measure until gorouter gained support, [we added an
  intermediate HAProxy to introduce `X-Forwarded-For` and `X-Forwarded-Proto`
  headers](https://www.pivotaltracker.com/story/show/116309951).
  
