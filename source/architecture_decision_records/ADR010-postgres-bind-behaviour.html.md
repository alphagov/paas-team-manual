---
title: ADR010 - Postgres bind behaviour
---

# ADR010: Postgres bind behaviour

## Context

We use RDS for tenant databases. Tenants can bind more than one application to a database instance created via the services console. Database migrations were broken when a binding was removed and re-added, or when another bound application other than the one that created the database tables attempted to modify them.

Previously the RDS broker PostgreSQL engine copied the MySQL engine and granted all rights on the database to the newly created user. In PostgreSQL this will give the user rights to create tables, but because it has a more finely-grained permission model than MySQL this does not give the user rights on existing tables, or tables newly created by other users.

Only the owner of a table can alter/drop it, and you cannot grant this permission to other users. Users who are the owners of tables cannot be removed until the table ownership is changed.

We attempted to work around the PostgreSQL permissions system in the following ways:

* Using [`ALTER DEFAULT PRIVILEGES`](https://www.postgresql.org/docs/9.5/static/sql-alterdefaultprivileges.html) on every newly created user to `GRANT ALL ON PUBLIC` - this means that every user can `SELECT`, `INSERT`, and `DELETE`, but because only the table owner can `ALTER` or `DROP` this will not allow other bound users to run migrations. This is also limited to the `PUBLIC` (default) schema, so would fail to work for any applications that have custom schemas.

* Making the group the owner of the `PUBLIC` schema. This allowed members of the group to `DROP` tables within the schema, but still did not allow them to `ALTER` these tables.

* Creating a "parent" group that is given ownership of all tables, sequences, and functions. New users are granted rights on this group and thus can carry out all owner actions on group-owned items. A [DDL event trigger](https://www.postgresql.org/docs/9.5/static/event-trigger-definition.html) using the built-in `REASSIGN OWNED BY` command handed over ownership of all resources owned by the current user to the parent `$DBNAME_owner` group. This worked perfectly on all the PostgreSQL databases we tested with, however RDS does not allow use of event triggers so it was unworkable in production.

## Decision

We decided the simplest solution was to issue the same credentials to all applications bound to the database. This means that the same user will be used by each application, and they will not suffer ownership problems when issuing `DROP` or `ALTER` commands.

Rather than deterministically deriving the credentials we decided to store them in the backing database itself meaning they can be changed at any time in case of a breach. To protect against database breaches that may leak stored credentials we also decided to encrypt the credentials using a symmetric key held by the broker.

We accepted that in the future we may wish to extend this by allowing the broker to issue read-only credentials, or credentials that are suitable for `SELECT`, `INSERT`, and `DELETE` operations, but not schema modifications.

## Status

Accepted

## Consequences

We return the same credentials to all apps bound to the same PostgreSQL database (RDS) instance.
