
appname                   = "superalgos"

region                    = "us-east-1"
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]

domain_name = "darklightventures.com"

support_team              = "DLV"

vpc_cidr                  = "10.42.0.0/19"
private_subnets           = ["10.42.128.0/23", "10.42.130.0/23", "10.42.132.0/23"]
public_subnets            = ["10.42.0.0/23", "10.42.2.0/23", "10.42.4.0/23"]


vpn_subdomain             = "vpn"


application_listen_port   = "34248"

application_listen_proto  = "tcp"


environment_live          = "live"
environment_paper         = "paper"


tags                      = {"support_team" = "DLV"}
