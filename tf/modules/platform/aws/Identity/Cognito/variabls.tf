
variable "dns_domain_name" {
    description                   = "DNS Domain Name"
    type                          = string
    default                       = "auth.hosted.superalgos.org"
}

variable "pool_client_name" {
  description                     = "The name of the user pool."
  type                            = string
  default                         = "superalgos-pool-client"
}

variable "user_pool_name" {
  description                     = "The name of the user pool."
  type                            = string
  default                         = "superalgos-user-pool"
}
