
variable "appname" {
    description = "Name of application"
    default = "Superalgos"
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
