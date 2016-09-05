Context
=======

We want to serve [HSTS
headers](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) for all
HTTPS requests to the apps domains, but it will safeguard existing users from
being MITMed over insecure connections and it will improve the user experience
when they click on a hostname that doesn't have a protocol.
(Note that without pre-loading in browsers this won't help first time users,
but that is out of context)

We want to leave open the option of able to override these headers from
the tenant application if they wish.

This feature requires conditionally process and modify the request headers.
There are several possible implementations:

 1. Implement the logic in the `gorouter` itself: `gorouter` shall process
   and add the header if required, by:
    * Supporting the specific HSTS headers, and allowing configure some
      sort of behaviour and default value.
    * Allow inject any additional header if they are missing.

   But [current `gorouter` implementation](https://github.com/cloudfoundry/gorouter/commit/0d475e57b1742c42ba6d98d1ed853edc9f709893)
   does not support any of these features, which require being added.

 2. Add some intermediate proxy (for example nginx, haproxy) in front of
   the go-routers and after the ELB.

 3. Implement it in a external CDN in front of PaaS origin (PaaS LB entry point):
   All the commercial CDN have the capacity to add additionally headers
   conditionally.

 4. AWS ELB: They do not support this logic and will not in the short term.
   In consequence they cannot be used to solve this problem.


Decision
========

We do not want to add any additional logic in the CDN, as they will
be an optional part of the platform and we will try to keep as simple
as possible.

We consider that the optional solution would be implement this logic in
the `gorouter`, but that requires some development effort and a PR being merged
upstream.

Because that we will implement, in the short term, the second option: a proxy
in front of the `gorouter`.

 * We will implement [HAproxy](http://www.haproxy.org/) in front of the go router.
   * Ha-proxy is the default LB solution for the official CF distribution.
   * It is really powerful and has good support.
   * Enough features to cover our needs.

 * It will be setup colocated with the `gorouter`, proxying directly to
   localhost.

 * We will do SSL termination in HAProxy, and plain text to `gorouter`. This
   is OK as the two services are colocated in the same VM.

 * We will reuse the code from [official haproxy job from cf-release](https://github.com/cloudfoundry/cf-release/tree/master/jobs/haproxy),
   although we will have to fork it to add additional settings in the
   haproxy configuration.


Future work:

 * We will implement and propose a PR to add logic in go-router to allow
   define additional headers.


Status
======

Accepted

Consequences
============

### Positive

 * We will be able to easily add more logic to rewrite the HTTP communication
   to the applications using HAProxy.

 * HAProxy SSL termination has better performance than `gorouter`, although
   this has a low impact because ELB is terminating the end user connections
   and using keep alive connections to the gorouter/haproxy.

 * HAProxy supports web-sockets and does HTTP multiplexing.

 * We can implement HTTP => HTTPS redirect in HAProxy.

### Negative

 * Adds some additional latency to every request.

 * We have to maintain our custom haproxy release.

 * Another moving part to monitor and take into account.

### See Also

[ADR012](ADR012-haproxy-healthcheck/)
