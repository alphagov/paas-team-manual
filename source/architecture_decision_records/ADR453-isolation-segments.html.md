# Isolation segments

## Status

Accepted

## Context

GOV.UK PaaS would like to be able to isolate specific tenant apps and tasks to
different pools of virtual machines (VMs).

GOV.UK PaaS would like to be able to prevent specific tenant apps and tasks
from egressing to the internet.

Apps running inside the separate pools of VMs should be able to discover and
access other apps running within the platform, providing that the correct Cloud
Foundry Network Policies have been created.

Apps running in the shared pools of VMs should be able to discover and access
apps running inside an isolation segment, providing that the correct Cloud
Foundry Network Policies have been created.

## Decision

GOV.UK PaaS will implement egress-restricted isolation segments.

Isolation segments will be configured by a GOV.UK PaaS developer, in a similar
manner to VPC peering connections.

Isolation segments will have the following variable properties:

- Number of instances (e.g. 1, 2, 3, 6)
- Instance type (e.g. small/large - maps to an AWS instance type + disk sizing)
- Whether egress to the internet is restricted

We will use iptables rules to achieve egress restriction. 

### Isolation segments

Cloud Foundry supports separating apps and tasks for specific Organizations
and Spaces via a feature called
[Isolation Segments](https://docs.cloudfoundry.org/adminguide/isolation-segments.html).

An Isolation Segment is a group of Diego cells with separate placement tags,
which map to the isolation segment name.

Isolation segments will be implemented as new instance groups defined in the
BOSH deployment manifest, with additional placement tags. A placement tag
corresponds to an isolation group name.

For example, an instance group with the placement tags:

- `fast-cpu`
- `fast-network`

enables us to run the following commands successfully:

- `cf create-isolation-segment fast-cpu`
- `cf create-isolation-segment fast-network`

which creates two isolation segments.

These isolation segments can be shared such that a segment can be:

- used by only a single organization or space
- shared by multiple organizations and spaces

### Egress restrictions

Container-to-container networking within Cloud Foundry is implemented via a
Virtual Extensible Local Area Network
([VXLAN](https://tools.ietf.org/html/rfc7348)).

Each container is assigned a virtual IP address inside the subnet 10.255/16

[Silk](https://github.com/cloudfoundry/silk)
and VXLAN use 
[iptables](https://linux.die.net/man/8/iptables)
(part of Linux kernel networking) via the Container Network Interface
([CNI](https://github.com/containernetworking/cni))
to create/update/delete iptables rules, to ensure containers can talk to each
other.

We can configure additional iptables rules to impose further restriction to
network traffic already defined by Silk and VXLAN. The additional rules can
have a higher precedence than the existing rules, allowing us to impose tighter
restrictions.

iptables can be used to prevent unauthorised egress via REJECT rules,
depending on the destination IP address. This can be done, either:

- In the global INPUT or FORWARD chains, with source IP qualifier to ensure only container traffic is affected
- In each container’s “netout” chain

Thus, any app traffic (from an IP address within 10.255/16) to a non-VPC
address (outside 10/8) can be blocked. These rules would be applied to running
apps and tasks, but not staging apps.

## Consequences

The implementation of isolation segments:

- will enable us to host apps which should not have access to the internet
- will enable us to host apps for users on separate virtual machines from other running on the platform
- will enable us to provision cells of different instance types
- will not interfere with normal Cloud Foundry container-to-container networking

The implementation of egress-restricted isolation segments:

- will not interfere with VPC peering, or brokered services which reside inside the platform VPC
- may interfere with app communication with brokered services which reside external to the platform VPC
- will not interfere with non-app traffic on the isolation segment virtual machines
- will not prevent future implementation of DNS masking for egress restricted apps

We will not have to change network topology, only virtual machine network configuration.

The maximum capacity of an isolation segment will be much smaller than the
shared pool. A tenant who wishes to immediately change their capacity within an
isolation segment will have to contact GOV.UK PaaS support.
