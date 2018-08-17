# Investigating `rsyslog` issues

`rsyslog` is ["the rocket-fast system for log
processing"](https://www.rsyslog.com/). It's an application that runs on all of
our VMs that receives log messages, performs some processing, and forwards the
messages to our logging system (currently logit).

We have occasionally suspected rsyslog (or other parts of our logging pipeline)
of causing reliability issues. This documentation is intended to help operators
diagnose issues with rsyslog more quickly.

## Suspected memory usage issues

On 2018-07-31 the production `router` virtual machines exhausted their
available memory and swap. Initial investigation suggested that the `rsyslogd`
process on these machines was using far more than the expected amount of
memory.

We investigated rsyslog's behaviour in situations where it can't ship logs to
its destination in [#159559834](https://www.pivotaltracker.com/story/show/159559834),
but weren't able to reproduce the issue. There's extensive documentation of our
investigation on that ticket.

### Investigating memory usage issues

If there are suspected issues with rsyslog's memory usage in future there are a
few things you should look into:

In Kibana, search for `@source.component: "rsyslogd-pstats"` - this should show
if rsyslog has full queues / is dropping messages. (See [#159559834](https://www.pivotaltracker.com/story/show/159559834/comments/193170947) for more details)

Use the bosh-cli to `ssh` onto a router, then:

```
# May show rsyslog-pstats messages that didn't make it to Kibana
tail -20000 /var/log/syslog | grep rsyslog-pstats

# How much CPU / memory are the rsyslog processes using?
ps uax | awk '/rsyslo[g]/ || NR==1'

# How much overall disk usage is there?
df -h | grep ^/

# How much overall memory usage is there?
free -o -m
```

It may also be useful to capture the traffic that rsyslog is sending to logit to investigate possible packet loss etc.

```
sudo tcpdump host "$(grep -o '[^@]*logit.io' /etc/rsyslog.d/35-syslog-release-forwarding-rules.conf)" -G 120 -W 1 -i eth0 -w logit-traffic.pcap
```
