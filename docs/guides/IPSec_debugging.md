## IPSec debugging


There may be a need, to debug the IPSec on our machines. In order to do that, you may want to log into `bosh-cli` and then `bosh ssh {router|cell}`.

### Fiddle with the logging level

Once logged into the VM, go ahead and edit the following file:

``
/var/vcap/jobs/racoon/etc/racoon/racoon.conf
``

And change the first line, from:

``
log 'info';
``

To:

``
log 'debug';
``

After changing the configuration, you may need to execute the following script, in order to apply the changes.

``
monit restart racoon
``

The log file, should be placed in:

``
/var/vcap/sys/log/racoon/racoon.log
``

### Verifying Configuration

You may find useful, to see changes applied to the kernel.

The configuration file for that, is located here:

``
/var/vcap/jobs/racoon/etc/setkey.conf
``

The values, from the configuration file, are taken to the consideration, when setting up the values to the kernel.

In order to check the validity, you may want to run these commands:

``
/var/vcap/packages/racoon/sbin/setkey -DP
/var/vcap/packages/racoon/sbin/setkey -D
``

More information on the script, can be found in the FreeBSD manual over at: https://www.freebsd.org/cgi/man.cgi?query=setkey&sektion=8

### Monitoring the traffic

You may find a desire, to monitor the traffic between the VMs. You can do so, by running the following command:

```
tcpdump -n -i eth0 net 10.0.48.0/22
```

If you want to restrict tcpdump to capture IPSEC traffic only you can use:

```
tcpdump -i eth0 -n -s 0 -vv \(port 500 or port 4500 or proto 50\)
```

**Note:** The IP address, may differ from the one set on the node you're debugging.

You should encounter the following outcome, which will consist of header, encrypted content and finally the key exchange.

```
16:31:09.873951 IP 10.0.48.101 > 10.0.32.4: ESP(spi=0x0be0677a,seq=0x6cf), length 84
16:31:09.874404 IP 10.0.48.101 > 10.0.32.4: ESP(spi=0x0be0677a,seq=0x6d0), length 84
16:31:09.874437 IP 10.0.32.4 > 10.0.48.101: ESP(spi=0x001c1bb1,seq=0x6d2), length 84
16:31:09.943974 IP 10.0.48.101.500 > 10.0.32.4.500: isakmp: phase 2/others ? inf[E]
16:31:09.944240 IP 10.0.32.4.500 > 10.0.48.101.500: isakmp: phase 2/others ? inf[E]
```

