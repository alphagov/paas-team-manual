Context
=======

In order to ensure the confidentiality of private tenant data processed on the platform we need to ensure that requests and responses for traffic between the user and application instances are encrypted so that it is not possible for a network eavesdropper to access private tenant data.

There are 3 main network sections between the user and the application:

* User to ELB
* ELB to router
* Router to cells

Decision
========

* The traffic between the user and the ELB is encrypted by using an TLS listener on the ELB. A certificate issued by a certificate authority is set on the ELB and access to the private key is very restricted.
* The ELB connects to the router VM via TLS. The router VM must, in consequence, serve TLS.
* The router to application instances traffic is plain HTTP because the Cloud Foundry doesn't support TLS between gorouter and the application instances and the application instances may not talk TLS. We've decided to use IPSec on router and cell so the traffic will be encrypted transparently.

Status
======

Accepted

Consequences
============

The traffic is encrypted end-to-end between the user and the applications.
