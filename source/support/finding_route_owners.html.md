---
title: Finding the owner of a route in cf
---

# Finding the owner of a route in cf

1. Install cf lookup-route plugin  with `cf install-plugin -r CF-Community "route-lookup"`
1. Log into the cf instance where you suspect the route is
1. Run `cf lookup-route DOMAINNAME` where DOMAINNAME is the one you are looking for
1. The output will tell you which org/space/app it it bound to
1. Run `cf org-users ORG-NAME` ORG-NAME is the first bit of the output from cf lookup-route
1. You now have a list of all the org managers

