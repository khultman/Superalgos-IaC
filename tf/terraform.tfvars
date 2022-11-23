
appname                   = "superalgos"

region                    = "us-east-1"
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]

domain_name               = "darklightventures.com"


vpc_cidr                  = "10.42.0.0/16"
application_subnet_cidr   = "10.42.0.0/19"
bastion_subnet_cidr       = "10.42.32.0/19"
private_subnet_cidr       = "10.42.64.0/19"


vpn_subdomain             = "vpn"


application_listen_port   = "34248"
websocket_listen_port     = "18041"


environment_live          = "live"
environment_paper         = "paper"


tags                      = {"support_team" = "DLV"}
