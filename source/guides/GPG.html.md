# How to use GPG

Some of our projects use [GPG][] to encrypt secrets so that they can only be
decrypted by members of the team. These instructions may be useful if you
haven't used GPG recently or ever at all.

[GPG]: https://www.gnupg.org/

## Install

On Mac OS X:

    brew install gpg gpg-agent

On Ubuntu:

    sudo apt-get update
    sudo apt-get install gnupg2 gnupg-agent pinentry-curses

## Generate keypair

To generate a new public and private keypair:

    gpg --gen-key

You should choose a key size of 4096 bits. The other defaults are OK to
accept.

## Publish key

Public keyservers are a simple way of distributing your public key so that
other people can download it and encrypt content for you.

Note: the following commands use the full fingerprint ID because there is a
risk of clashes when using the shortened last 8 digits (which is the
default).

To list your keys:

    gpg -K --fingerprint

The output will look something like the following:

    sec   4096R/22652456 2013-02-06
          Key fingerprint = 9562 E7AD 3A95 E7BC 708D  036F F894 D400 2265 2456
    uid                  Dan Carley (Government Digital Service) <dan.carley@digital.cabinet-office.gov.uk>
    ssb   4096R/233AD793 2013-02-06

Take the long ID listed after `Key fingerprint =` and run:

    gpg --keyserver keyserver.ubuntu.com --send-keys 'YOUR ID HERE …'

You will need to provide the same ID to an existing member of the team so
that they can add you to any secret stores that you need access to.

## Setup agent

If you're accessing several secrets in quick succession then it can be
frustrating to be prompted for your password multiple times. You can
configure `gpg-agent`, which is similar in concept to `ssh-agent`, to cache
your password for a short period of time.

Write the following to your shell initialisation (such as `~/.bashrc` or
`~/.zshrc`) to load `gpg-agent` each time you start a new shell:

    if which gpg-agent >/dev/null; then
      GPG_ENV_FILE="${HOME}/.gnupg/gpg-agent.env"
      if ! pgrep gpg-agent >/dev/null; then
        gpg-agent --daemon --write-env-file "${GPG_ENV_FILE}" >/dev/null
      fi
      if [ -f "${GPG_ENV_FILE}" ]; then
        source "${GPG_ENV_FILE}"
        export GPG_AGENT_INFO
      fi
    fi

Configure gpg to use the agent automatically by uncommenting the `use-agent`
line in your `~/.gnupg/gpg.conf`.

## Aborting pinentry

If you abort out of the `pinentry` password prompt by using `^C` then it can
leave your shell and GPG in an unusable state. Symptoms include:

- any characters you type appear as `*`
- output from commands is incorrectly line breaked
- subsequent calls to `gpg` hang

You can fix this by killing any outstanding `pinentry` processes:

    pkill -9 pinentry

And resetting your terminal with:

    reset
