---
title: ADR047 - Postgres allowed-extensions approach
---

# ADR047: Postgres allowed-extensions approach

## Context

Up to the release of postgres 13 plans to tenants, the policy for choosing
the set of postgres extensions we allow for a certain major version was ad-hoc.
A mixture of "allow everything", simply copying the list from the previous
postgres version and not actually trying any of these extensions had lead
to an extensions list (published at https://docs.cloud.service.gov.uk/deploying_services/postgresql/#add-or-remove-extensions-for-a-postgresql-service-instance)
with:

 - misnamed entries
 - entries removed from earlier postgres versions
 - missing newly-offered extensions
 - extensions that could never be used without superuser access
 - extensions that could never be used with the VPC restrictions we have
   in place for our RDS instances.

Some of these extensions had been omitted from the list in the documentation,
but it was unclear how these decisions had been made and where we stood on
each extension.

This is confusing for tenants and could lead them down a path of trying to
use an extension which will never work, or even start designing a system
that relies on functionality in a listed extension only to find it unusable.

## Decision

For postgres 13 onwards, offer a selection of extensions limited to those
we know can be successfully enabled and think are feasible to use given
the limitations of our platform.

Maintain a document (initially a spreadsheet https://docs.google.com/spreadsheets/d/100qBo3Q2mfY70ek9fNWbpEsS4HzjOarF3q1a_hPR1uU/edit?usp=sharing)
tracking our conclusions on each extension by postgres major version.

When preparing to offer a new postgres major version to tenants, a new
sheet should be copied from the previous release's sheet and adjusted
according to the new list of extensions in the RDS documentation. New
entries should be researched and decided upon whether they are feasible
to use without superuser privileges and from within our VPC.

Using a dev environment with the new postgres available and a script
such as the one found in
https://github.com/alphagov/paas-rds-broker/tree/main/scripts (or preferably
an improved one), each extension remaining in the "final list" should be
checked in turn to ensure it can be enabled and then disabled. This may
involve discovering (through trial and error) which extensions have
dependencies on others. It's likely to be the same as the previous release,
so that's a good starting point. This is good information to maintain as it
would come in useful if we ever decided to make the rdsbroker smarter and able
to auto-load dependencies.

This should also reveal whether any new extensions require
`shared_preload_libraries`. Any that do should have appropriate additions
made to https://github.com/alphagov/paas-rds-broker/blob/main/rdsbroker/supported_extensions.go .

Beyond making sure an extension loads, actually trying out the functionality
of each extension is beyond the time committment we're willing to give
this for now. We may update the documentation to note the semi-supported
nature of postgres extensions on our platform.

## Status

Accepted

## Consequences

Adding a new major postgres version will take a little more work than before.

There's a possibility we'll mistakenly disable an extension that _would_
prove useful to a tenant in some way. In this case they can always ask us
about it and we may re-assess. It's not as though we're removing an
extension from a current database.
