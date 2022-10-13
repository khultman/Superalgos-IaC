
/*==== application load balancer security group ======*/
resource "aws_security_group" "sg_loadbalancer" {
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


/*==== application load balancer ======*/
resource "aws_lb" "loadbalancer" {
  name               = "${var.environment}-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_loadbalancer.id]
  subnets            = [for subnet in ${module.networking.} : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}


