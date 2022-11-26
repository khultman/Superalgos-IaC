# Superalgos Deployment Scripts for AWS

This project is designed to deploy the Superalgos project securely to aws

It is very much a prototype, not functional, and a work in progress.


## Design

### Authentication and Application Traffic Flow
![Authentication and Application Traffic Flow](design/diagram-authentication-paper-us-east-1.png)

### Management Traffic Flow
![Management Traffic Flow](design/diagram-management-paper-us-east-1.png)



### Authentication

Authentication to [Superalgos](https://superalgos.org/) is handled by the
Internet facing application load balancer and aws cognito.

### Instances

* EC2 Nodes have been chosen to host the instance on.
* EBS Volumes will be attached to each node
  * Storage will be set to persist allowing it to be re-used or inspected
 

#### Considerations

***EKS + EC2***, ***EKS + Fargate***, ***ECS + EC2***, ***ECS + Fargate*** were
considered for this design:

##### EKS

Both EC2 and Fargate backed EKS

| PROs                | CONs  |
|---------------------|-------| 
| Flexible            | Cost  |
| Easy to manage      |       |
| Extremely Scalable  |       |


##### ECS

Both EC2 and Fargate backed ECS

| PROs | CONs |
|---------------------|------------------------------------| 
| Flexible            | Lack of control                    |
| Easy to manage      | Limited persistent storage options |
| Scalable            | |
| Cost effective      | |


### Management Access

* A client vpn will be established to the bastion subnets
* SSH access to the `bastion` host security group will be permitted from the client vpn source address
* Application Security Group will permit SSH access from the Bastion Security Group

