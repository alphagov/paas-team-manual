# Pairing

We pair on all stories to ensure that people don't get stuck on the same
types of work and that there is a good distribution of knowledge across the
team. We aim to rotate regularly, when starting new stories. However you can
opt-out of a rotation if it would be detrimental to the progress of your
current story. Please tick the [pair stair][] on our board when you rotate
so that rotation are evenly distributed.

[pair stair]: http://pairstair.com/

# Story kick-off

Kick-offs are an opportunity to clarify the scope of a story and raise any
technical suggestions or concerns before work starts. When a pair starts a
new story they should arrange a kick-off with the Business Analyst, Tech
Arch or Tech Lead, and anyone else from the team that is interested. Slack
is a good way to let the team know.

# Commit messages

Commit messages are very useful as documentation, so please take time to
detail what you are changing and why. The [GOV.UK git style guide][]
explains this in more detail.

[GOV.UK git style guide]: https://github.com/alphagov/styleguides/blob/master/git.md

# Pull requests

We peer review all code to ensure that it works as expected and is clear for
the team to understand. All work, no matter how small, should use git
branches and GitHub pull requests. [Anna's blog post][] explains how to
raise a good pull request.

[Anna's blog post]: http://www.annashipman.co.uk/jfdi/good-pull-requests.html
[this template]: https://github.com/alphagov/paas-cf/blob/master/.github/PULL_REQUEST_TEMPLATE.md

When you create a pull request please:

- use [this template][] for the description so that it is easier for
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

# Story summary

When you've finished a story please take a few minutes to summarise your
work in a comment on the Pivotal story. This is particularly important if
the story was a spike and doesn't result in any pull requests. Summarising
the story will help other people in the team review it, either against the
acceptance criteria or for future reference, which can otherwise be
difficult if comments are sparse or inconsistent.

# Story sign-off

## What sign-off is

When the work on a story is completed and any changes merged to master, we
check that it met the original business need that motivated the story and that
acceptance criteria have been met.

We ensure that if the story changed scope, identified other problems that need
to be solved, or incurred technical debt, that stories have been created to
capture the remaining work.

If the changes have already been tested to your satisfaction during review,
then sign-off need not include testing.

## Who signs off stories

Who can sign off the story is agreed and recorded in the story at kick-off, but
by default will be the Product Manager. The Product Manager can delegate
signing off specific stories to civil servants within the team.

When a story moves to awaiting sign-off column on the board, The Tech Lead and
Tech Arch should confirm if they are happy with the story in a comment on
Pivotal Tracker to provide guidance to the person signing off.

# Creating and forking repos

Nearly all of our code repos are public on GitHub.com because we are [coding
in the open][]. There is an exception to this, where a public repo could
risk leaking sensitive information. When creating or forking a new repo you
will need to do the following. If you're a contractor then you'll need to
ask a permanent member of the team to do this for you:

[coding in the open]: https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/

1. Prefix the name with `paas-` so that it's easier to find. This includes
forks of third-party repos which will need to be renamed after forking, e.g.
`cf-release` would become `paas-cf-release`.
1. Add the Pivotal Tracker service integration/hook. You will need to take
the API key from the "Profile" page of your own account.
1. Add the following teams:
    1. `team-government-paas-readonly`: the dashboard user which has
`org:read` privileges to find all of our repos.
    1. `team-government-paas-contractors`: all members of the team that are
contractors and aren't members of the `owners` team.

We should never pull request against the `master` branch of a forked repo.
Doing so makes it very hard to reconcile our changes against the upstream
repo at a later date. We should aim to submit all changes upstream. It may
be appropriate to run against a branch of our fork for a limited period of
time.
