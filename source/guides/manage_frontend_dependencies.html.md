---
title: Manage frontend dependencies
---

# Manage frontend dependencies

GOV.UK Platform as a Service team has four major web apps that require regular maintenance:

- [paas admin](https://github.com/alphagov/paas-admin)
- [product pages](https://github.com/alphagov/paas-product-pages)
- [tech docs](https://github.com/alphagov/paas-tech-docs)
- [team manual](https://github.com/alphagov/paas-team-manual)

## PaaS admin
PaaS admin is a server-side rendered React web app. It utilises NPM dependencies and it will have by far the most dependency updates.
Dependabot is set up to raise dependecy update pull requests and security audits. Tests are set up and demand 100% code coverage.

On merge to `main`:

 - tests run and if sucessful, a [git tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging) with a version number is [created](https://concourse.build.ci.cloudpipeline.digital/teams/main/pipelines/paas-admin/jobs/tag-releases), and updated in the [paas-admin version file](https://github.com/alphagov/paas-admin/blob/main/version)
 - once the tag is created, staging tests and deployment commence; if sucessful, a new git tag is created (`stg-lon-<datetime>`)
 - if staging deployment is sucessful, production deployment goes ahead

Pull request merge commits must be signed with a [team member's GPG key](https://github.com/alphagov/paas-cf/blob/main/concourse/vars-files/gpg-keys.yml), which can be done using the GDS CLI tool (`gds git merge-sign alphagov/paas-admin PR_NUMBER`). 

Do not merge through the GitHub UI.

## Product Pages

Product pages are a set of static pages built by [NextJS](https://nextjs.org/). It utilises NPM dependencies and will have many fewer dependency updates than PaaS admin
Dependabot is set up to raise dependecy update pull requests and security audits. 

There are some tests set up but it's recomended to run a local static build for bigger updates,
which is documented in the [`paas-product-pages` README](https://github.com/alphagov/paas-product-pages#review-static-build-production-build)

Dependabot pull requests need to be approved and can be merged in the Github web UI.

## Tenant-facing tech docs and team manual

Tech docs and team manual are implementations of the [`tech-docs-gem`](https://github.com/alphagov/tech-docs-gem), a Ruby gem that distributes the [Tech Docs Template](https://github.com/alphagov/tech-docs-template). The Tech Docs Template is a [middleman template](https://middlemanapp.com/advanced/project_templates/) that you can use to build technical documentation using a GOV.UK style.

In addition to the upstream tech-docs-gem dependency there are some local Ruby dependencies. Dependabot will raise update pull request against all dependencies, but it's always best to check if a new version of the gem has been released. Follow the project READMEs to get started.

Dependabot pull requests can be merged in the Github web UI.


## Management strategies
Some of the strategies to use when managing updates

- read release notes

Most packages will have some release notes. Even though they might use [semantic versioning (semver)](https://semver.org/), it doesn't mean a fix/patch update doesn't contain major changes.

Most packages below version 1, don't necessarily use semVer. When in doubt, check usage in our codebase.

- run locally to check the build (if needed)

If you're unsure about package changes, need to run tests (locally or against staging, etc) or wish to manually check everything is OK, all of these have the ability to run locally.

- merge and deploy one dependency at a time

Sometimes there are unexpected staging or production build or test failures, so a good strategy is to merge and deploy one at a time. That way you can easily roll back the commit and continue with other dependencies.

In case of `paas-admin`, if a staging tag is created, all is ok. All others are deployed straight to production.


### Audit installed NPM dependecies

- [`npm ls <package name>`](https://docs.npmjs.com/cli/v7/commands/npm-ls)
This will list all the versions of packages that are installed. 

Example output for `npm ls got`

```
├─┬ nodemon-webpack-plugin@4.8.0
│ └─┬ nodemon@2.0.16
│   └─┬ update-notifier@5.1.0
│     └─┬ latest-version@5.1.0
│       └─┬ package-json@6.5.0
│         └── got@9.6.0
└─┬ openid-client@4.9.1
  └── got@11.8.1
```

- [`npm explain <package name>`](https://docs.npmjs.com/cli/v8/commands/npm-explain)
This will list the chain of dependencies causing a given package to be installed in the current project, a "bottoms up" view of why a given package is included in the tree at all.

Example output for `npm explain got`

```
got@9.6.0 dev
node_modules/got
  got@"^9.6.0" from package-json@6.5.0
  node_modules/package-json
    package-json@"^6.3.0" from latest-version@5.1.0
    node_modules/latest-version
      latest-version@"^5.1.0" from update-notifier@5.1.0
      node_modules/update-notifier
        update-notifier@"^5.1.0" from nodemon@2.0.16
        node_modules/nodemon
          nodemon@"2.0.16" from nodemon-webpack-plugin@4.8.0
          node_modules/nodemon-webpack-plugin
            dev nodemon-webpack-plugin@"^4.8.0" from the root project

got@11.8.1
node_modules/openid-client/node_modules/got
  got@"^11.8.0" from openid-client@4.9.1
  node_modules/openid-client
    openid-client@"^4.9.1" from the root project
```

### Audit and update NPM sub-dependecies


[`npm audit [fix]`](https://docs.npmjs.com/cli/v8/commands/npm-audit)

Submits a description of the dependencies configured in the project to the default registry and asks for a report of known vulnerabilities. 
If any vulnerabilities are found, then the impact and appropriate remediation will be calculated. 
If the `fix` argument is provided, then remediations will be applied to the package tree.

If dependabot has raised an alert about a potential security vulnerabilities in project dependencies, you can use `npm audit` to check for any packages that can be updated.

Example output of `npm audit`

```
No fix available
node_modules/got
node_modules/openid-client/node_modules/got
  package-json  <=6.5.0
  Depends on vulnerable versions of got
  node_modules/package-json
    latest-version  0.2.0 - 5.1.0
    Depends on vulnerable versions of package-json
    node_modules/latest-version
      update-notifier  0.2.0 - 5.1.0
      Depends on vulnerable versions of latest-version
      node_modules/update-notifier
        nodemon  >=1.3.5
        Depends on vulnerable versions of update-notifier
        node_modules/nodemon
          nodemon-webpack-plugin  *
          Depends on vulnerable versions of nodemon
          node_modules/nodemon-webpack-plugin

6 moderate severity vulnerabilities

Some issues need review, and may require choosing
a different dependency.
```
