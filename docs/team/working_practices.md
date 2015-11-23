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

We record merged pull requests in Pivotal Tracker using a GitHub service
integration, so that we can later see all of the code changes for a given
story. When you create a pull request you should put the ID of the story in
the title (format: `[#12345678] My pull request`) which will later form the
merge commit. Please do not add the story ID to individual commits, as this
creates a lot of noise in Pivotal.

There is a dashboard near our desks that displays open pull requests using
[Fourth Wall][]. Reviewing outstanding pull requests should be a priority
over picking up new work. As the author of a pull request you may still need
to chase this and you need to watch your email for comments on your pull
request. Pull requests should be reviewed by somebody that hasn't already
worked on the story.

[Fourth Wall]: https://github.com/alphagov/fourth-wall
