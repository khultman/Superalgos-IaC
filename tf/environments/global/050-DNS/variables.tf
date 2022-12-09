variable "reference_name" {
    description                   = "Reference Name of delegation set"
    default                       = "superalgos"
}

variable "dns_domain_name" {
    description                   = "DNS Domain Name"
    type                          = string
    default                       = "hosted.superalgos.org"
}
