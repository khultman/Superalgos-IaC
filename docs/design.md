# Design

This document documents the design of hosting the [Superalgos](https://superalgos.org) trading application securely in a cloud provider, specifically AWS. To understand the design choices and rationale, please see the [Design Considerations](design-considerations.md) document. The design diagrams are codified and generated from [diagram.py](../scripts/diagram.py).


## EC2 Node Configuration

Each EC2 node will be configured with a local nginx proxy using TLS certificates,
ensuring all trafic that transits to and from the superalgos application to the
external world will be encrypted.
* Note: This ***assumes*** but **does not ensure** that all traffic to and from the superalgos application will be authenticated and/or authorized

![EC2 Node Configuration](design/diagram-superalgos-node-paper-us-east-1.png)

## Authentication and Application Traffic Flow
![Authentication and Application Traffic Flow](design/diagram-authentication-paper-us-east-1.png)

## Management Traffic Flow
![Management Traffic Flow](design/diagram-management-paper-us-east-1.png)


## Authentication

Authentication to [Superalgos](https://superalgos.org/) is handled by the
Internet facing application load balancer and aws cognito.

## Instances

* EC2 Nodes have been chosen to host the instance on.
* EBS Volumes will be attached to each node
  * Storage will be set to persist allowing it to be re-used or inspected
 

