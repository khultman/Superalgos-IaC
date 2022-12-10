
variable "domain_name" {
    description                   = "DNS Domain Name"
    type                          = string
    default                       = "cert.hosted.superalgos.org"
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

variable "zone_id" {
  description                     = "The Route53 Zone ID"
  type                            = string
}