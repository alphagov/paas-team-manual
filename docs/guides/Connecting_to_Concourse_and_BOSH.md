## SSH into the Concourse VM

We can SSH directly into the Concourse VM using a Makefile target in `paas-bootstrap`. This copies the Concourse VM's SSH key from a state bucket on S3, prints the VM's sudo password, and makes the SSH connection.

```
make ssh_concourse
```

---

## Connecting bosh_cli to BOSH

A Makefile task in `paas-bootstrap` pulls a Docker image and runs a container loaded with the secrets required to interact with Bosh using the CLI:

```
DEPLOY_ENV=foo make dev bosh-cli
```

The container will automatically login and target the CF deployment.

If you want to target the `concourse` deployment you have to define it for your commands specifically, e.g.:

```
bosh -d concourse vms
```

#### Bosh SSH

To SSH to Bosh-managed VMs you need to go via a gateway, as they aren't exposed publicly. We use the Bosh VM as the gateway - this is set up automatically. From inside the container you can run:

```
bosh ssh router/bd695524-353e-43ef-84a6-4e256537bd95
```

---

## SSH into the BOSH VM

There is a Makefile task in `paas-bootstrap` to establish this SSH connection.  This copies SSH keys for the BOSH VM from a state bucket on S3, prints the BOSH VM's sudo password, and makes the SSH connection.

```
make ssh_bosh
```
