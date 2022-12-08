variable "zone_id" {
    description                   = "The ID of the hosted zone to contain this record."
}

variable "name" {
    description                   = "The name of the record."
    type                          = string
}

variable "type" {
    description                   = "The record type. Valid values are A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT."
    type                          = string
    default                       = "A"
}

variable "ttl" {
    description                   = "(Required for non-alias records) The TTL of the record."
    type                          = number
}

variable "records" {
    description                   = "(Required for non-alias records) A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM, add \\\"\\\" inside the Terraform configuration string (e.g., \"first255characters\\\"\\\"morecharacters\")"
    type                          = string
}

variable "set_identifier" {
    description                   = "Unique identifier to differentiate records with routing policies from one another. Required if using failover, geolocation, latency, multivalue_answer, or weighted routing policies documented below."
    string                        = string
    default                       = null
}

variable "health_check_id" {
    description                   = "The ID of the health check to be associated with this record."
    string                        = string
    default                       = null
}

variable "alias" {
    description                   = "An alias block. Conflicts with ttl & records."
    default                       = null
}

variable "failover_routing_policy" {
    description                   = "A block indicating the routing behavior when associated health check fails. Conflicts with any other routing policy."
    default                       = null
}

variable "geolocation_routing_policy" {
    description                   = "A block indicating the routing behavior based on geographic location. Conflicts with any other routing policy."
    default                       = null
}

variable "latency_routing_policy" {
    description                   = "A block indicating the routing behavior based on latency. Conflicts with any other routing policy."
    default                       = null
}

variable "weighted_routing_policy" {
    description                   = "A block indicating the routing behavior based on weighted routing. Conflicts with any other routing policy."
    default                       = null
}

variable "multivalue_answer_routing_policy" {
    description                   = "A block indicating the routing behavior based on multivalue answer routing. Conflicts with any other routing policy."
    default                       = null
}

variable "tags" {
    description                   = "A mapping of tags to assign to the resource."
    type                          = map(string)
}

variable "tags_for_resource" {
  description                     = "A nested map of tags to assign to specific resource types"
  type                            = map(map(string))
}
