---
title: ADR052 - Automating dependency updates
---

# ADR052 - Automating dependency updates

## Context

GOV.UK PaaS consumes a large number of package-level dependencies, across several package ecosystems; Go modules, Ruby
gems, NodeJS packages, Terraform modules, and GitHub Actions [1]. This has given us a big surface area to maintain,
and to have security vulnerabilities in.

The team is good at updating and maintaining component-level dependencies, such as [`cf-deployment`](https://github.com/cloudfoundry/cf-deployment),
but has historically been poor at updating its package-level dependencies. We have made attempts to improve in the past,
namely enabling [GitHub's Dependabot](https://github.com/dependabot), which have had some success. However, our large
surface area has resulted in a large number of pull requests which require our attention to review and merge.
This is especially true for [`paas-admin`](https://github.com/alphagov/paas-admin) which is written in TypeScript and
has a high rate of churn among its dependencies.

A large number of PRs for a small team like that of GOV.UK PaaS is not sustainable alongside other work, and being lax with
dependency updates and their security fixes is not something we should be doing.

## Proposal

This ADR proposes to automate merging patch version dependency bumps, as raised by Dependabot.

### What

In general, the packages consumed by GOV.UK PaaS conform to [semantic versioning](https://semver.org/) rules[2], which
allows us to make some assumptions about the changes introduced in a version change. In a semantically versioned package,
the patch version "MUST be incremented if only backward compatible bug fixes are introduced". By definition, we can
believe that if tests are passing after a patch version bump, then the change of version has had no negative impact.

Therefore, we can safely merge a PR for a patch version change once all of its status checks have passed.

Minor versions are similarly defined in the semantic versioning spec ("MUST be incremented if new, backward compatible
functionality is introduced to the public API."), however experience tells us that package authors more frequently
disrespect the specification for minor versions than patch versions, and as as such minor and major version bumps are
out of scope for this ADR. A future ADR may address them.

### How

#### Background

GOV.UK PaaS' staging pipeline is triggered by the presence of a new commit at the tip of the `main` branch. It requires
that the commit be signed by a GPG key belonging to an engineer on the team, and once the commit has run through the
pipeline successfuly it is given a tag whose format triggers the production pipelines. The production pipelines repeat
the GPG signature validation.

Requiring that commits be signed is a mitigation against an attacker managing to get a commit on to the tip of `main`.
Were an attacker able to do so, but was not able to sign it using an engineer's GPG key, the commit would not get
deployed to eventually make its way into production.

A known, and accepted, risk is a malicious commit making its way onto `main` followed by a correctly signed genuine
commit. In this instance, the content of the malicious commit would run through the pipelines as the parent commit of
the genuine commit.

#### Implementation

This ADR proposes to implement automatic merging of eligible PRs using
[Dependabot and GitHub's automatic PR merging](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/automating-dependabot-with-github-actions#enable-auto-merge-on-a-pull-request).
An eligible PR has 

* been raised by Dependabot
* [Dependabot metadata](https://github.com/dependabot/fetch-metadata) showing it is a patch version bump
* status checks which have passed

Automatic PR merging is a feature enabled and configured at the PR level in GitHub. It can only be enabled for PRs
which cannot be merged immediately because, for example, a branch protection rule requires that all configured status
checks have passed prior to merging. In order to consistently apply the necessary configuration across many
repositories, the GOV.UK PaaS team will need to automate the configuration of its GitHub repositories. Doing so is out
of scope for this ADR.

The workflow itself would be given write permissions on the repository via a personal accses token[3] so that it can merge
the PR using the `gh` CLI tool.

To avoid the problem of not being able to sign the commit with an engineer's GPG key, this ADR proposes to add a new
commit filter to the Concourse git resource, such that commits containing text like `[skip: dependency update]` do not
trigger a pipeline run, and cannot break the pipeline. As mentioned earlier, we should believe by definition that patch
version changes whose tests pass are correct, thus skipping them in the pipelines should have no impact.


## Status

DRAFT

## Consequences


[1] We also have dependencies on Git submodules, but they are component-level dependencies and out of scope.

[2] It is true that some packages follow the scheme, but not the rules. Handling that fact is out of scope for this ADR.
    A future ADR could present a mechanism for special handling of specific packages.
    
[3] Managing personal access tokens is out of scope for this ADR.