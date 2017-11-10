## SSH into the Concourse VM

We can SSH directly into the Concourse VM using a Makefile target in `paas-bootstrap`. This copies the Concourse VM's SSH key from a state bucket on S3, prints the VM's sudo password, and makes the SSH connection.

```
make ssh_concourse
```

---

## Connecting bosh_cli to BOSH

A Makefile task in `paas-bootstrap` pulls a Docker image and runs a container loaded with the secrets required to interact with Bosh using the CLI:

```
DEPLOY_ENV=foo make bosh-cli
```

The container will automatically login to and target Bosh. It will not select a deployment automatically, as you may want to target the Concourse deployment or Cloud Foundry. To target the deployment:

```
bosh download manifest <deployment> manifest.yml
bosh deployment manifest.yml
```

#### Bosh SSH

To SSH to Bosh-managed VMs you need to go via a gateway, as they aren't exposed publicly. We use the Bosh VM as the gateway. To avoid you having to set the gateway details manually we have a simple wrapper script for setting them for you. From inside the container you can run:

```
bosh-ssh router/0
```

Otherwise you have to set them manually:

```
bosh ssh \
  --gateway_host "$BOSH_IP" \
  --gateway_user vcap \
  --gateway_identity_file /tmp/bosh_id_rsa \
  router/0
```

---

## SSH into the BOSH VM

There is a Makefile task in `paas-bootstrap` to establish this SSH connection.  This copies SSH keys for the BOSH VM from a state bucket on S3, prints the BOSH VM's sudo password, and makes the SSH connection.

```
make ssh_bosh
```
