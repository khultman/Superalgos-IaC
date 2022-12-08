variable "name" {
  description                     = "This is the name of the hosted zone."
  type                            = string
}

variable "comment" {
  description                     = "A comment for the hosted zone. Defaults to 'Used by Superalgos'."
  type                            = string
  default                         = "Used by Superalgos"
}

variable "delegation_set_id" {
  description                     = "The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc as delegation sets can only be used for public zones."
  default                         = null
}

variable "force_destroy" {
    description                   = "Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
    type                          = bool
    default                       = false
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

variable "vpc" {
  description                     = "Configuration block(s) specifying VPC(s) to associate with a private hosted zone. Conflicts with the delegation_set_id argument in this resource and any aws_route53_zone_association resource specifying the same zone ID. Detailed below."
  type                            = list(map(string))
  default                         = []
}