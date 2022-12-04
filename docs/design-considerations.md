# Design Considerations

* [***EKS***](#eks)
* [***ECS***](#ecs)


## Overall Considerations

* The deployment MUST be automatable.
* Any user with minimal technical ability SHOULD be able to configure and deploy the infrastructure.
* Any user with minimal technical ability SHOULD be able to connect to the deployed application.
* The trading platform MUST be fault tolerant.
* Superalgos provides no built-in security, we MUST protect the access to a reasonable level:
    * A user MUST be authenticated
    * Data MUST be encrypted in flight.
    * Data MUST be encrypted in rest.
* The operational cost SHOULD be as low as possible.


## EKS

**Both EC2 and Fargate backed EKS**

| PROs                | CONs  |
|---------------------|-------| 
| Flexible            | Cost  |
| Easy to manage      |       |
| Extremely Scalable  |       |


## ECS

**Both EC2 and Fargate backed ECS**

| PROs | CONs |
|---------------------|------------------------------------| 
| Flexible            | Lack of control                    |
| Easy to manage      | Limited persistent storage options |
| Scalable            | |
| Cost effective      | |


## Management Access

* A client vpn will be established to the bastion subnets
* SSH access to the `bastion` host security group will be permitted from the client vpn source address
* Application Security Group will permit SSH access from the Bastion Security Group
