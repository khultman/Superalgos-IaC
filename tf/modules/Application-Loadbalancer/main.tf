

/*==== application load balancer security group ======*/
resource "aws_security_group" "sg_alb" {
  name        = "${var.environment}-sg-loadbalancer"
  description = "Loadbalancer Security Group"
  vpc_id      = "${module.Networking.vpc_id}"
  depends_on  = ["${module.Networking}"]
  
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  
  tags = {
    Environment = "${var.environment}"
    Application = "${var.appname}"
    Team        = "${var.team}"
  }
}