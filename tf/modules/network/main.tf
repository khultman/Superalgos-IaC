


module "vpc" {
  source                  = "../platform/aws/networking/vpc"
  cidr_block              = "${var.vpc_cidr}"
  enable_dns_support      = true
  enable_dns_hostnames    = true
  tags                    = "${var.tags}"
  tags_for_resource       = "${var.tags_for_resource}"
}



