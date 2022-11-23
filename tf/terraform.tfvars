
appname                   = "superalgos"

region                    = "us-east-1"
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]

domain_name               = "darklightventures.com"


vpc_cidr                  = "10.40.0.0/14"


vpn_subdomain             = "vpn"


application_listen_port   = "34248"
websocket_listen_port     = "18041"


environment_live          = "live"
environment_paper         = "paper"


tags                      = {"support_team" = "DLV"}
