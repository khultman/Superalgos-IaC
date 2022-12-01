
variable "appname" {
    description                   = "Name of application"
    default                       = "superalgos"
}

# variable "availability_zones" {
#     description                   = "Availability Zones"
#     default                       = ["us-east-1a", "us-east-1b", "us-east-1c"]
# }

variable "domain_name" {
    description                   = "Root domain name, e.x foo.com"
    default                       = "set-the-domain-name.com"
}

variable "environment" {
    description                   = "Name tag of the Environment"
    default                       = "set-the-environment"
}


variable "vpc_cidr" {
    description                   = "CIDR Block for VPC"
    default                       = "10.42.0.0/19"
}

variable "application_subnet_cidr" {
    description                   = "Private subnet cidr block"
    default                       = "10.42.0.0/19"
}

variable "bastion_subnet_cidr" {
    description                   = "Public subnet cidr block"
    default                       = "10.41.32.0/19"
}

variable "public_subnet_cidr" {
    description                   = "Public subnet cidr block"
    default                       = "10.40.64.0/19"
}

# The address range cannot overlap with the target network address range, 
# the VPC address range or any of the routes that will be associated with the 
# Client VPN endpoint. The client address range must be at minimum /22 and not 
# greater than /12 CIDR block size. You cannot change the client address range 
# after you create the Client VPN endpoint
variable "vpn_client_cidr" {
    description                   = "CIDR Block for VPN Client"
    default                       = "10.21.0.0/16"
}

variable "vpn_subdomain" {
    description                   = "Subdomain for client vpn endpoints, creates zone within the root domain, e.x bar for bar.foo.com"
    default                       = "vpn"
}

variable "ec2_application_port" {
    description                   = "The port the aplication listens on"
    default                       = "8443"
}

variable "ec2_websocket_port" {
    description                   = "The port the aplication websocket listens on"
    default                       = "8041"
}

variable "application_listen_port" {
    description                   = "The internal port the aplication listens on"
    default                       = "34248"
}

variable "websocket_listen_port" {
    description                   = "The aplication websocket internal port"
    default                       = "18041"
}

variable "application_listen_proto" {
    description                   = "The Protocol the application listens on [e.g tcp/udp]"
    default                       = "tcp"
}

variable "min-instances" {
    description                   = "Minimum number of application instances"
    default                       = 1
}

variable "max-instances" {
    description                   = "Maximum number of application instances"
    default                       = 1
}

variable "region" {
    description                   = "Region"
    default                       = "us-east-1"
}

variable "tags" {
  description                     = "A map of tags to assign to resources"
  type                            = map(string)
  default                         = {}
}

variable "tags_for_resource" {
  description                     = "A nested map of tags to assign to specific resource types"
  type                            = map(map(string))
  default                         = {}
}
