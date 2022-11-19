
variable "appname" {
  description = "Name of application"
  type        = string
}

variable "region" {
  description = "AWS Deployment Region"
  type        = string
}

variable "support_team" {
  description = "Owning or Supporting application team"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones to create the subnets in"
  type        = list(string)
}

variable "propagating_vgws" {
  description = "A list of virtual gateways for route propagation"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "tags_for_resource" {
  description = "A nested map of tags to assign to specific resource types"
  type        = map(map(string))
  default     = {}
}

# Public subnet variables

variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into these subnets"
  type        = string
  default     = false
}

variable "gateway_id" {
  description = "The ID of the Internet Gateway to use for routing"
  type        = string
}
