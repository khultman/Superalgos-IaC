
appname                   = "superalgos"

region                    = "us-east-1"
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]

domain_name               = "set-the-domain-name.com"


vpc_cidr                  = "10.42.0.0/16"
application_subnet_cidr   = "10.42.0.0/19"
bastion_subnet_cidr       = "10.42.32.0/19"
private_subnet_cidr       = "10.42.64.0/19"


vpn_subdomain             = "vpn"
vpn_client_cidr           = "10.21.0.0/16"


# These are the configured ports that NGINX listens on
ec2_application_port      = "8443"
ec2_websocket_port        = "8041"

# These are the configured ports that the NGINX is communicating to internally
application_listen_port   = "34248"
websocket_listen_port     = "18041"


environment_live          = "live"
environment_paper         = "paper"


tags                      = {
    "support_team"        = "Support Team"
}


tags_for_resource         = {
    "vpc"                 = {
        "tag_example"     = "superalgos_vpc"
    }
}
