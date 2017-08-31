## SSH into the Concourse VM

We can SSH directly into the Concourse VM using a Makefile target in `paas-cf`. This copies the Concourse VM's SSH key from a state bucket on S3, prints the VM's sudo password, and makes the SSH connection.

```
make ssh_concourse
```

---

## Connecting bosh_cli to BOSH

### Primary solution: use a Concourse task

A Makefile task in `paas-cf` connects you to a one-off task in concourse that's already logged into bosh and has the deployment set using the CF manifest:

```
make dev bosh-cli
```

### Backup solution: tunnel BOSH commands through SSH

If you can't use the task on Concourse, you can tunnel local `bosh` commands to the deployment's BOSH. 

1. First install `bosh` with `gem install bosh_cli`.
2. Second [establish an SSH connection to the BOSH VM](#ssh-into-the-bosh-vm).
3. Third run the `scripts/bosh_cli_tunnel.sh` script in `paas-cf`. This forwards the BOSH port, logs you into BOSH and and drops you into a `bash` session to run `bosh` commands:

Alternatively you can append `-L 25555:localhost:25555` to the SSH commands in order to establish the tunnel, and login to BOSH manually.

---

## SSH into the BOSH VM

### Primary solution: tunnel through the Concourse VM

In ordinary circumstances we use the Concourse VM as a gateway to access the BOSH VM. There is a Makefile task in `paas-cf` to establish this SSH connection.  This copies SSH keys for the Concourse and BOSH VMs from a state bucket on S3, prints the BOSH VM's sudo password, and makes the SSH connection.

```
make ssh_bosh
```

### Backup method: tunneling through a new VM

Should the Concourse VM be overloaded or missing, we can create a new EC2 instance and use it as a gateway to the BOSH VM.

Go into EC2 and create a new VM:

* It must be on the VPC network of your deployment.
* It may need to be on an `infra` subnet.
* It must be assigned a public IP.
* It must have both the `office-access-ssh` and `bosh-ssh-client` security groups. This gives SSH access from the GDS Office and SSH access to the BOSH VM.
* It must use the `${DEPLOY_ENV}_key_pair` key pair for the script below to work.

Use the `scripts/ssh_bosh_temporary_gateway.sh` script in `paas-cf` to SSH into the BOSH VM using this new VM as a gateway. You must first define the new VM's public IPv4 address as a `VM_IP` environment variable, for instance `VM_IP=53.33.78.122`.

You should terminate the new VM once you're done.

### Emergency method: connecting directly to BOSH

If the Concourse VM is unavailable and creating new VMs is impossible or would take too long, you can make the BOSH VM accessible to our IP addresses. This should be a last-resort and temporary measure.

Go into EC2 and add the `bosh/0` VM to the `office-access-ssh` security group. You should now be able to SSH to its public IP address using the `scripts/ssh_bosh_expose_vm.sh` script in `paas-cf`.

**Important: remove the `office-access-ssh` security group from `bosh/0` once you're done.**
