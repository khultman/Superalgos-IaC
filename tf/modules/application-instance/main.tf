



/*==== application instance security group ======*/
resource "aws_security_group" "sg_app" {
  name        = "${var.environment}-sg-appinstance"
  description = "Application Instance Security Group"
  vpc_id      = "${module.networking.vpc_id}"
  depends_on  = ["${module.networking}"]
  
  tags = {
    Environment = "${var.environment}"
    Application = "${var.appname}"
    Team        = "${var.team}"
  }
}

/*==== application instance security group rule: LB -> APP ======*/
resource "aws_security_group_rule" "sg_rule_loadbalancer_to_app" {
    type                     = "ingress"
    from_port                = "${var.application_listen_port}"
    to_port                  = "${var.application_listen_port}"
    protocol                 = "${var.application_listen_proto}"
    security_group_id        = "${aws_security_group.sg_app.id}"
    source_security_group_id = "${module.application-loadbalancer.sg_alb.id}"
}


