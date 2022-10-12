
variable "appname" {
    description = "Name of application"
    default = "Superalgos"
}

variable "domain_name" {
    description = "Root domain name, e.x foo.com"
    default = "darklightventures.com"
}

variable "region" {
    description = "AWS Deployment Region"
    default = "us-east-1"
}

variable "support_team" {
    description = "Owning or Supporting application team"
    default = "DLV"
}

variable "vpc_cidr" {
    description = "CIDR Block for VPC"
    default = "10.42.0.0/19"
}

variable "vpn_subdomain" {
    description = "Subdomain for client vpn endpoints, creates zone within the root domain, e.x bar for bar.foo.com"
    default = "vpn"
}
