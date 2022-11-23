



variable "appname" {
    description           = "Name of application"
    default               = "superalgos"
}

variable "domain_name" {
    description           = "Root domain name, e.x foo.com"
    default               = "set-the-domain-name.com"
}

variable "environment" {
    description           = "Name tag of the Environment"
    default               = "set-the-environment"
}

variable "vpc_cidr" {
    description           = "CIDR Block for VPC"
    default               = "10.42.0.0/19"
}

variable "vpn_subdomain" {
    description           = "Subdomain for client vpn endpoints, creates zone within the root domain, e.x bar for bar.foo.com"
    default               = "vpn"
}

variable "application_listen_port" {
    description           = "The port the aplication listens on"
    default               = "8080"
}

variable "application_listen_proto" {
    description           = "The Protocol the application listens on [e.g tcp/udp]"
    default               = "tcp"
}

variable "subnets" {
    description           = "Map of the subnets to be created"
    type                  = map(map(string, string))
    default               = {
        "public"          = {
            "cidr_bits"   = "23"
            "count"       = "3"
            }
        "application"     = {
            "cidr_bits"   = "23"
            "count"       = "3"
        }
        "bastion"         = {
            "cidr_bits"   = "23"
            "count"       = "3"
        }
    }
}

data "aws_availability_zones" "available" {
    state = "available"
}

locals {
    availability_zones = data.aws_availability_zones.available.names
}

locals {
    public_subnets = [
        for az in local.availability_zones : 
            "${lookup(var.subnets, "public")}.${local.cidr_c_private_subnets + index(local.availability_zones, az)}.0/${lookup(var.subnets)}"
        ]
    application_subnets = [
        for az in local.availability_zones : 
            "${lookup(var.cidr_ab, "application")}.${local.cidr_c_database_subnets + index(local.availability_zones, az)}.0/24"
        ]
    bastion_subnets = [
        for az in local.availability_zones : 
            "${lookup(var.cidr_ab, "bastion")}.${local.cidr_c_public_subnets + index(local.availability_zones, az)}.0/24"
        ]
}

# variable "private_subnets" {
#     description           = "List of Private Subnets"
#     default               = ["10.42.128.0/23", "10.42.130.0/23", "10.42.132.0/23"]
# }

# variable "public_subnets" {
#     description           = "List of Public Subnets"
#     default               = ["10.42.0.0/23", "10.42.2.0/23", "10.42.4.0/23"]
# }

variable "tags" {
  description             = "A map of tags to assign to resources"
  type                    = map(string)
  default                 = {}
}

variable "tags_for_resource" {
  description             = "A nested map of tags to assign to specific resource types"
  type                    = map(map(string))
  default                 = {}
}



# locals {
#   availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
#   private_subnets = ""
#   public_subnets = ""
# }

