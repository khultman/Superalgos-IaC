



/*==== application instance security group ======*/
resource "aws_security_group" "sg_app" {
  name        = "${var.environment}-sg-appinstance"
  description = "Application Instance Security Group"
  vpc_id      = "${module.Networking.vpc_id}"
  depends_on  = ["${module.Networking}"]
  
  ingress {
    from_port       = "34248"
    to_port         = "34248"
    protocol        = "tcp"
    security_groups = "${aws_security_group.sg_alb.id}"
  }
  
  tags = {
    Environment = "${var.environment}"
    Application = "${var.appname}"
    Team        = "${var.team}"
  }
}

