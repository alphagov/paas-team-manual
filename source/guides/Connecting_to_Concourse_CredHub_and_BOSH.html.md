# Connecting to Concourse, CredHub, and BOSH

## Single sign-on

We use Google single sign-on (SSO)
to represent an audited identity instead of shared credentials.

We use SSO for operator workflows, for instance:

- Using BOSH via the `bosh-cli` task
- Interacting with CredHub directly via the `credhub` shell task
- Uploading secrets to CredHub via the `upload-secrets` task

## SSH into the Concourse VM

To SSH directly into the Concourse VM, use `make` in `paas-bootstrap`.

```
make ssh_concourse
```

## Connecting bosh_cli to BOSH

<a id="connecting-bosh_cli-to-bosh"></a>

A Makefile task in `paas-bootstrap` pulls a Docker image,
sets some environment variables to aid with signing in,
and runs a container targeting BOSH:

```
DEPLOY_ENV=foo make dev bosh-cli
```

The container will automatically target the CF deployment.
To target the `concourse` deployment directly,
you have to define it for your commands specifically, e.g.:

```
bosh -d concourse vms
```

### Bosh SSH

To SSH to Bosh-managed VMs you need to go via a gateway, as they aren't exposed publicly.
We use the Bosh VM as the gateway - the task sets this up automatically.
From inside the container you can run:

```
bosh ssh router/bd695524-353e-43ef-84a6-4e256537bd95
```

## SSH into the BOSH VM

We use the Makefile task in `paas-bootstrap` to establish this SSH connection.

```
make ssh_bosh
```

## Interact with CredHub

To interact with CredHub directly, use `make` in `paas-cf`.

```
make dev credhub
```

and follow the instructions.

To upload secrets:

- Enter a CredHub subshell (`make dev credhub`)
- Log in to CredHub (`credhub login --sso`)
- Run the secrets task (`make upload-all-secrets`)
