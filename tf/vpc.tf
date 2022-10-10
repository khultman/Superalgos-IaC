resource "aws_vpc" "superalgos" {
  cidr_block = "10.42.0.0/19"

  tags = {
    Name = "Superalgos"
    usedBy = "Superalgos"
    supportedBy = "dlvFinOps"
  }
}