
output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}

output "subnet_public_cidr_blocks" {
  value = [for s in aws_subnet.subnet_public : s.cidr_block]
}