

variable "domain_name" {
    description           = "Root domain name, e.x foo.com"
    default               = "set-the-domain-name.com"
}


variable "environment" {
    description           = "Name tag of the Environment"
    default               = "set-the-environment"
}


# The address range cannot overlap with the target network address range, 
# the VPC address range or any of the routes that will be associated with the 
# Client VPN endpoint. The client address range must be at minimum /22 and not 
# greater than /12 CIDR block size. You cannot change the client address range 
# after you create the Client VPN endpoint
variable "vpn_client_cidr" {
    description           = "CIDR Block for VPN Client"
    default               = "10.21.0.0/16"
}


variable "vpn_subdomain" {
    description           = "Subdomain for client vpn endpoints, creates zone within the root domain, e.x bar for bar.foo.com"
    default               = "vpn"
}


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

