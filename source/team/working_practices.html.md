---
title: Working practices
---

# Working practices

## These are guidelines, not rules

We've found these working practices highly effective, but they're a living document
open to discussion and change. They won't necessarily work for everyone without
some adjustment. If something doesn't seem to be working for you, it's OK to challenge
that and ask for things to improve.

For our wider cultural practices, see the GDS
[It's OK](https://gds.blog.gov.uk/2016/05/25/its-ok-to-say-whats-ok/) poster. For
instance it's okay to ask for help, it's okay to have quiet days, and many other things.

# Development process

![Illustration of changes being promoted to prod](/diagrams/development-process.svg)

[Full size version](/diagrams/development-process.svg)

The development process consists of the following steps:

1. The Product Manager makes decisions on which work (for example, features or bugs) to prioritise.

2. The team make the necessary changes in their own development environments on feature branches.

3. An engineer reviews the changes in a [pull request](#pull-requests).

4. The reviewer merges the changes into the master branch of the repository.

5. The Cloud Foundry smoke and acceptance tests automatically test the latest revision of the code in staging to make sure that basic user functions still work.

6. The changes are deployed to the production environment.

7. The team move the card to the 'Done' column of the Pivotal Tracker and a team member with appropriate access signs off the work.


![Sequence of events promoting a release](/diagrams/release-sequence.svg)

[Full size version](/diagrams/release-sequence.svg)

The release process consists of the following steps:

1. Developers (engineers) commit code to a development branch on a git repository.

2. When the development is complete, a developer raises a pull request against the main branch of the git repository for review.

3. Another team member reviews the pull request and if there are no problems, merges the changes into the main branch. Alternatively, they may provide feedback to the developers and request corrections and/or additional work.

4. A new commit to the main branch triggers a Concourse git_resource that performs an automated deployment to the staging environment.

5. The staging environment runs automated tests.
  - 5 a. If the deployment or tests fail, the automated release process is halted and the team is notified.
  - 5 b. If the deployment is successful and all tests pass, the main branch commit is tagged for release to production.

6. A new release tag triggers a Concourse git_resource that performs an automated deployment to the production environment.

This process does not include the use of git commit signatures which we use to
verify developer and merger identity for a number of git
repositories.

## Pairing

We pair on all stories to ensure that people don't get stuck on the same
types of work and that there is a good distribution of knowledge across the
team. We aim to rotate pairs regularly by:

- changing pairs when you've been on a story for more than 2 days

- joining someone on an existing story that doesn't have a pair instead of
  picking up new work

We don't insist on a particular method of pairing. We're keen to have two people
making decisions and aware of the story, but there are lots of ways those two
people can work together. Sometimes a pair shares one computer; other times a pair
splits stories into pieces they can work on individually. Discuss what works for
both of you.

## Commit messages

Commit messages are very useful as documentation, so please take time to
detail what you are changing and more importantly why. The [GDS git style
guide][] explains this in more detail.

[GDS git style guide]: https://github.com/alphagov/styleguides/blob/master/git.md

If something is worth detailing in a pull request description then it is
also worth detailing in a commit message. Commit messages will live with the
repository forever and can be discovered using [git pickaxe][], whereas over
time a project may move from GitHub or Pivotal Tracker. You can often
copy/paste well written commit messages to form the pull request
description.

[git pickaxe]: http://www.philandstuff.com/2014/02/09/git-pickaxe.html

## Creating and forking repos

Nearly all of our code repos are public on GitHub.com because we are [coding
in the open][]. There is an exception to this, where a public repo could
risk leaking sensitive information. When creating or forking a new repo you
will need to do the following. If you're a contractor then you'll need to
ask a permanent member of the team to do this for you:

[coding in the open]: https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/

1. Prefix the name with `paas-` so that it's easier to find. This includes
forks of third-party repos which will need to be renamed after forking,
for example `cf-release` would become `paas-cf-release`.
1. Add the Pivotal Tracker service integration/hook. You will need to take
the API key from the ["Profile" page](https://www.pivotaltracker.com/profile) of your own account.
1. Add the following teams:
    1. `[team] Government PaaS readonly`: the dashboard user which has
`org:read` privileges to find all of our repos.
    1. `[team] Government PaaS - People`: all members of the team that are
contractors and aren't members of the `owners` team. These should be given write
access.

We should never pull request against the `master` branch of a forked repo.
Doing so makes it very hard to reconcile our changes against the upstream
repo at a later date. We should aim to submit all changes upstream. It may
be appropriate to run against a branch of our fork for a limited period of
time. We have decided to use a branch called `gds_master` for this, although
some older repositories may use something else. Feel free to change these as
you encounter them, to improve consistency.

## Pull requests

We peer review all code to ensure that it works as expected and is clear for
the team to understand. All work, no matter how small, should use git
branches and GitHub pull requests. [Anna's blog post][] explains how to
raise a good pull request.

[Anna's blog post]: http://www.annashipman.co.uk/jfdi/good-pull-requests.html
[the pull request template]: https://github.com/alphagov/paas-cf/blob/master/.github/PULL_REQUEST_TEMPLATE.md

When you create a pull request please:

- use [the pull request template][] for the description so that it is easier for
  the reviewer to understand and test your changes

- prefix the subject with the story ID from Pivotal Tracker (format:
  `[#12345678] My pull request`) so that we have a record of all the changes
  for a given story

- put the pull request URL into the Pivotal Tracker story so that
  people can find it and understand the progress of a story before it is
  merged

There is a dashboard near our desks that displays open pull requests using
[Fourth Wall][]. Reviewing outstanding pull requests should be a priority
over picking up new work. As the author of a pull request you may still need
to chase this and you need to watch your email for comments on your pull
request. Pull requests should be reviewed by somebody that hasn't already
worked on the story. When reviewing a pull request please "assign" yourself
on GitHub, so that someone else doesn't duplicate effort.

[Fourth Wall]: https://github.com/alphagov/fourth-wall

## Merging Pull requests

Once review is complete, and all status checks have passed (GitHub Actions etc),
a pull request can be merged.

PRs to the [paas-cf][] and [paas-bootstrap][] repositories should be merged using a GPG signed commit.
This means that merges can't be done in the Github UI. They have to be done locally.

We only use signed revisions of [paas-cf][] and [paas-bootstrap][] from our concourse pipelines.
This is enforced by the gpg functionality in Concourse Git resource. We may require signing merges in other repositories in future.

[paas-cf]: https://github.com/alphagov/paas-cf
[paas-bootstrap]: https://github.com/alphagov/paas-bootstrap

### Managing allowed signers

For every repository we are forcing commit signing on there will be a file called `.gpg-id` in the root directory. It should contain
the public key IDs of every key which is allowed to sign commits. There will also be a helper script for generating the necessary
vars file for Concourse. For example:

```bash
cd paas-cf
make update_merge_keys
```

Run the helper script and commit the changes every time you change the contents of `.gpg-id`.

### Initial setup for signing commits

Ensure you have gpg setup on your machine (see our [GPG guide](/guides/GPG/) for
details).

By default, git will look for a secret key in your local keyring that exactly
matches your configured committer name and email address (such as
`Testy McTest <test@example.com>`). If this is not sufficient, you can
configure the signing key that git will use:

```sh
## To apply to all git repos:
git config --global user.signingkey <key_id>

## ... or to apply to the current repo only:
git config user.signingkey <key_id>
```

Add your public key to your Github account
([https://github.com/settings/keys](https://github.com/settings/keys)) so that
Github can verify commits that you sign as described
[here](https://github.com/blog/2144-gpg-signature-verification).

You must also upload your key to the `keys.openpgp.org` key server and validate the email
address associated with it, so that others can automatically retrieve your key.

### Merging a branch into `main`

The [GDS CLI](https://github.com/alphagov/gds-cli) has a utility for merging and signing PRs for you. If
you have a GDS managed machine, `gds` will already be installed. You should read [the GDS CLI documentation](https://github.com/alphagov/gds-cli)
for a guide on configuring it with the correct credentials. Merging with GDS CLI requires a GitHub API token,
which you must provide in the `GITHUB_API_TOKEN` environment variable.

PRs can be merged and signed by running:

```sh
gds git merge-sign ORG/REPO PR_NUMBER
```

Where `ORG` is the name of the GitHub organisation, `REPO` is the name of the repository, and `PR_NUMBER` is the
number of the pull request.

`gds` will checkout and merge the PR in a clean, temporary directory and leave your working directory untouched.

# Stories

## Pivotal Tracker and Rubbernecker

We use [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/1275640) to track stories and [Rubbernecker](https://rubbernecker.cloudapps.digital/) for an overview of stories currently being worked. Stories without a name assigned to them are available for you to work on. You should remove your name when moving a story to the next step (e.g. "doing" to "review").

## Story states
Within Pivotal Tracker there are a number of [story states](https://www.pivotaltracker.com/help/articles/terminology/#state) that let you know where in the cycle that piece of work is. When these stories are being worked, they appear in Rubbernecker. They appear under columns with different titles but when selecting a state in pivotal they move into the Rubbernecker columns like so:

  -  started > doing
  -  finished > reviewing
  -  delivered > approving
  -  accepted > done
  -  rejected > rejected (column only appears in Rubbernecker if there is a rejected story)

![Pivotal and Rubbernecker story states](https://user-images.githubusercontent.com/35229192/125968961-9d65291f-3308-4352-b8b3-317c50542fdf.png)

## Assigning labels to stories
Pivotal Tracker stories give the option to tag the story with labels. We use these labels to filter the stories to understand the work being done, help with planning sessions and to feed into relevant governance reports (PaaS Operational Dashboard).

The labels being used by the team are as follows :

- `2024-update`: Routine upgrades of core components
- `2024-security-update`: Reactive upgrades of core components
- `2024-scale`: Scaling operations
- `2024-correct`: Corrective/remedial changes to infrastructure
- `2024-optimise`: Making improvements to existing systems
- `2024-deprecate`: Service deprecations
- `2024-comms`: Tenant comms
- `2024-investigate`: Investigative/exploratory changes
- `2024-features`: Feature work
- `2024-decomm`: Decommissioning Work
- `2024-governance`: All of the non-engineering work needed to keep GOV.UK PaaS running

These may be updated periodically as the team identify new and appropriate labels. You should apply appropriate epics using the 'linked epic label' (a purple label that is assigned to a specific epic/mission) where appropriate.

## Story kick-off

Kick-offs are an opportunity to clarify the scope of a story and raise any
technical suggestions or concerns before work starts. They should include a
check if the story being kicked off will likely conflict with any of the
stories already in progress and therefore likely cause conflicts.

If the story is a spike, it should be made clear what the questions we want to answer
are, and what specific outputs we need to cover in the summary at the end of the spike. Spikes *must* be
reviewed after 2 days.

When a pair starts a new story they should arrange a kick-off with the
Feature Lead or Tech Lead and anyone else from the team that is interested.
Slack is a good way to let people know.

## Story summary

When you've finished a story please take a few minutes to summarise your
work in a comment on the Pivotal story. Summarising
the story will help other people in the team review it, either against the
acceptance criteria or for future reference, which can otherwise be
difficult if comments are sparse or inconsistent.

### Spike summary

The summary is particularly important if the story was a spike. If applicable
it must indicate follow up work that is required. Listing options uncovered during
the spike is good. Indicate which option is preferable. Where possible follow up stories
should be noted. Doing this allows the Product Manager prioritise the follow up work.

## Review

Review is the step in our process where the pull requests relating to a story
are code-reviewed, and merged. This is typically done by somone who hasn't
worked on the story, however if a story has been paired on throughout, the pair
can merge their own PRs, and push the story straight through to approval.

For a story that hasn't been paired on throughout, the review and merging must
be done by someone who hasn't worked on it. This is to ensure that all code has
been read by at least 2 people before being released to prod.

## Approval

The Approval step in the process is where we verify that the story is fully
complete according to our definition of done (below).

Approval should be done by the Feature Lead or Tech Lead, as they have overall
responsibility for the progress of the relevant epic.

### Our definition of done

- the work on a story is completed
- it met the need that motivated the story
- any changes merged to master
- the work is deployed to production
- any acceptance criteria have been met
- new stories are written for any follow-up work or technical debt

If it changes behaviour or makes new features available to users:

- we have updated the developer documentation
- we have notified our users (before we make the change if necessary)

## Technical Documentation Changes

Technical Documentation changes follow the same overall process as code changes, but with several documentation-specific amends. This section summarises the tech docs change process.

### Pre kick-off

- Required: technical writer

Before the formal story kick-off, the technical writer reviews the story and drafts changes if possible.

### Kick-off

- Required: technical writer, technical lead
- Optional: product representative, developer

At this step, decide on what changes to the tech docs are required to complete this story. You must also agree on who needs to review and approve this story. Make sure that you decide whether the story needs product as well as technical review. If no specific technical reviewers are named, any developer can serve as the technical reviewer. You should also analyse if any other further changes or stories will result from this story.

### Doing

- Required: technical writer, developer

Draft the content changes in markdown, ensuring that it is technically correct and in line with the GDS style guide. You must preview changes in tech doc format so that the new or amended content is smoothly integrated into the exsting documentation structure. Evaluate if story needs to change, and if so, whether this can be included in the scope of the original story or should be part of a new story. Once you have agreed that the content is ready for further review, raise a pull request to the paas-tech-docs repo.

Note that if the change requires product review, you must push the tech doc changes to Cloud Foundry for review. Refer to the [Deploy a static site](https://docs.cloud.service.gov.uk/#deploy-a-static-site) for instructions on how to do this.

### Reviewing

- Required: technical writer, developer, technical writer 2i
- Optional: product representative, tech lead

Three reviews should happen at the same time:

- The developer reviews the content in both GitHub and in the tech doc preview, checking if it addresses the issues in the story.
- The tech writer conducting the 2i review checks the style and content.
- The product rep or tech lead reviews content if required; the product rep will look at the temporary Cloud Foundry version of the tech docs.

Implement any changes as required, and then get sign-off from reviewers. The reviewers then merge the changes once they have been signed off.

### Approving

- Required: tech writer, approver

The approver checks if the change deployed correctly, and whether it addresses the story. If it does so, they approve the story.
