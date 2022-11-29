from __future__ import annotations

import argparse
import sys

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.general import InternetGateway
from diagrams.aws.management import AutoScaling, Cloudwatch
from diagrams.aws.network import ALB, ClientVpn, NATGateway, VpnConnection
from diagrams.aws.security import Cognito
from diagrams.aws.storage  import ElasticBlockStoreEBSVolume, S3
from diagrams.onprem.certificates import LetsEncrypt
from diagrams.onprem.client import User
from diagrams.onprem.compute import Server
from diagrams.onprem.network import Internet, Nginx
from diagrams.onprem.vcs import Github


# Set this to the name or ID of your AWS account
# aws_account_alias = "Superalgos"
aws_account_alias = "Superalgos"

# Set this to the name of the environment
# environments = ["live", "paper"]
environments = ["paper"]


# Set this to the port number nginx will be listening on for front-end traffic
nginx_app_port = 8443

# Set this to the port number nginx will be listening on for ws traffic
nginx_ws_port = 8041


# Set this to the list of region names the app will be deployed to
# region = ["us-east-1"]
regions = ["us-east-1"]


# Set this to the application port
# sa_app_port = 34248
sa_app_port = 34248

# Set this to the desired number of SA instances
# sa_instances = 1
sa_instances = 2

# Set this to the subdomain you're 
# sa_subdomain = "superalgos"
sa_subdomain = "superalgos"

# Set this to your top level domain if want to customize the diagram
# sa_TLD = "mydomain.com"
sa_TLD = "mydomain.com"

# Set this to the TLS port on the Internet facing AWS ALB
# sa_tls_port = 443
alb_tls_port = 443

# Set this to the websocket port
# sa_ws_port = 18041
sa_ws_port = 18041

# Set this to the desired ssh port
# ssh_port
ssh_port = 22

# The CIDR block of the vpc, this should a /16
# vpc_cidr = "10.42.0.0/16"
vpc_cidr = "10.42.0.0/16"

# The application subnets CIDR block, this should be large enough
# to yield a /24 per availability zone - recommendation is a /19 or /20
# application_subnet_cidr = "10.42.0.0/19"
application_subnet_cidr = "10.42.0.0/19"

# The bastion subnets CIDR block, this should be large enough
# to yield a /24 per availability zone - recommendation is a /19 or /20
# bastion_subnet_cidr = "10.42.32.0/19"
bastion_subnet_cidr = "10.42.32.0/19"

# The public subnets CIDR block, this should be large enough
# to yield a /24 per availability zone - recommendation is a /19 or /20
# public_subnet_cidr = "10.42.64.0/19"
public_subnet_cidr = "10.42.64.0/19"

# Set this to the subdomain of the vpn
# vpn_subdomain = "vpn"
vpn_subdomain = "vpn"

# The vpn client subnets CIDR block, this should be large at least
# twice the size as required client connections [cite](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/what-is.html#what-is-limitations)
# and at least a /22 and no larger than a /12
# Recommendation is a /19 or /20 for consistency
# public_subnet_cidr = "10.42.64.0/19"
vpn_subnet_cidr = "10.42.96.0/19"


# This will generate a mapping of instance details which will be used later
# for generating the detailed diagram
sa_instance_mapping = [
    {
        "idx": i,
        "tls_port": f"8{alb_tls_port + i}",
        "sa_app_port": sa_app_port + i,
        "sa_ws_port": sa_ws_port + i
    }
    for i in range(1, sa_instances+1)
]



# Shortcut functions for pre-defined line styles
def boldGreen(label="", color="darkgreen", style="bold"):
    return Edge(label=label, color=color, style=style)


def dashedRed(label="", color="firebrick", style="dashed"):
    return Edge(label=label, color=color, style=style)


def dottedGreen(label="", color="darkgreen", style="bold, dotted"):
    return Edge(label=label, color=color, style=style)


def saInstance(label=""):
    return EC2(label)


def solidBlack(label="", color="black", style=""):
    return Edge(label=label, color=color, style=style)

def solidBlue(label="", color="darkblue", style=""):
    return Edge(label=label, color=color, style=style)

def solidGreen(label="", color="darkgreen", style=""):
    return Edge(label=label, color=color, style=style)


def solidRed(label="", color="firebrick", style="solid"):
    return Edge(label=label, color=color, style=style)


#

def awsAccount(elements):
    graph_attrs = {
        "fontsize": 30
    }
    elements["aws_account_cluster"] = Cluster(f"AWS Account: {aws_account_alias}")
    elements["internet"] = Internet("Public Internet")
    elements["user"] = User("User")


#

def authTrafficFlow(environment, region, fqdn, out_dir: str = '.', graph_attr = {}):
    with Diagram("Superalgos IaC", filename=f"{out_dir}/diagram-authentication-{environment}-{region}", outformat="png", show=False, graph_attr=graph_attr):
        elements = {}
        authTrafficInfrastructure(elements=elements, region=region, fqdn=fqdn)
        # User -> Application traffic flow
        elements["user"] >> solidRed(f"1: Establish Client VPN") >> elements["internet"] >> solidRed(f"1: Establish Client VPN") >> elements["vpn_endpoint"] >> solidRed(f"1: Establish Client VPN") >> elements["vpn_connection"]
        #
        elements["vpn_connection"] >> dashedRed(f"2: Request https://{fqdn}") >> elements["external_lb"]
        #
        elements["external_lb"] >> solidRed("3: Authenticate and Authorize User") >> elements["cognito"] 
        elements["cognito"] >> dottedGreen("4: Valid Authorization Response") >> elements["external_lb"]
        #
        elements["external_lb"] >> solidGreen("5: Authenticated Traffic Flow to backend") >> elements["app_instances"]
        elements["app_instances"] >> solidGreen("6: Application Response") >> elements["external_lb"]
        elements["external_lb"] >> solidGreen("7: ALB Application Response to user") >> elements["vpn_connection"] >> solidGreen("7: ALB Application Response to user") >> elements["vpn_endpoint"] >> solidGreen("7: ALB Application Response to user") >> elements["internet"] >> solidGreen("7: ALB Application Response to user") >> elements["user"]
        # Application Internal Traffic Routing
        elements["app_instances"][0] >> solidGreen(f"8: Internal unsecured WS and HTTP Communication:\n`ws://{fqdn}:{nginx_ws_port}[+NodeIndex]`\n`http://{fqdn}:{nginx_app_port}[+NodeIndex]`") >> elements["internal_lb"]
        elements["internal_lb"] >> solidGreen(f"9: Internal traffic hairpin") >> elements["app_instances"][-1]
        # Application Logging
        elements["external_lb"] >> dashedRed("10: Access Logs :: ALB/Application") >> elements["cloud_watch"] >> dashedRed("10: Access Logs Read-Only Storage :: ALB/Application") >> elements["s3_access"]
        # VPN Access Logs
        elements["vpn_endpoint"] >> dashedRed("10: Access Logs :: VPN Client ") >> elements["cloud_watch"] >> dashedRed("10: Access Logs Read-Only Storage :: VPN Client") >> elements["s3_vpnlogs"]
        

def authTrafficInfrastructure(elements, region, fqdn):
    awsAccount(elements)
    with elements["aws_account_cluster"]:
        elements["region"] = Cluster(f"Region: {region}")
        with elements["region"]:
            elements["cloud_watch"] = Cloudwatch("AWS Cloudwatch")
            elements["cognito"] = Cognito("AWS Cognito")
            elements["s3_access"] = S3(f"access-logs.{fqdn}")
            elements["s3_vpnlogs"] = S3(f"vpn-logs.{fqdn}")
            elements["vpn_endpoint"] = ClientVpn(f"{vpn_subdomain}.{fqdn}")
            elements["vpc_sa"] = Cluster(f"Superalgos VPC :: {vpc_cidr}")
            #
            with elements["vpc_sa"]:
                elements["subnet_application"] = Cluster(f"Application Subnet :: {application_subnet_cidr}")
                elements["subnet_public"] = Cluster(f"Public Subnet :: {public_subnet_cidr}")
                elements["subnet_vpn"] = Cluster(f"VPN Subnet :: {vpn_subnet_cidr}")
                # Public Subnet Objectes
                with elements["subnet_public"]:
                    elements["sg_alb"] = Cluster("SG: ALB")
                    with elements["sg_alb"]:
                        elements["external_lb"] = ALB("VPN-Facing ALB")
                # Application Subnet Object
                with elements["subnet_application"]:
                    elements["sg_sa_nodes"] = Cluster("SG: Superalgos Nodes")
                    elements["sg_internal_lb"] = Cluster("SG: Internal LB")
                    # SG: Internal LB Object
                    with elements["sg_internal_lb"]:
                        elements["internal_lb"] = ALB("Internal ALB")
                    # SG: SA Nodes Object
                    with elements["sg_sa_nodes"]:
                        elements["app_instances"] = [
                            saInstance(f"{i.get('idx')}.{fqdn}")
                            for i in sa_instance_mapping
                        ]
                # VPN Subnet Object
                with elements["subnet_vpn"]:
                    elements["vpn_connection"] = VpnConnection("Client VPN Connection")
            # Add connections from each SA Node to an EBS Volume
            for idx, i in enumerate(sa_instance_mapping):
                elements["app_instances"][idx] - ElasticBlockStoreEBSVolume(f"sa_ebs_{i.get('idx')}")


def superalgosNodeDiagram(environment, region, fqdn, out_dir: str = '.', graph_attr = {}):
    with Diagram("Superalgos IaC - Superalgos Node", filename=f"{out_dir}/diagram-superalgos-node-{environment}-{region}", outformat="png", show=False, graph_attr=graph_attr):
        elements = {}
        with Cluster(f"Superalgos Node"):
            elements["certificates"] = LetsEncrypt("LetsEncrypt Self-Signed Certificates")
            elements["nginx"] = Nginx("Nginx Reverse Proxy")
            elements["superalgos"] = Server("Superalgos Application")
        #
        elements["nginx"] >> solidBlack("Load Self-Signed Certificates") >> elements["certificates"]
        elements["certificates"] >> elements["nginx"]
        #
        elements["nginx"] >> solidBlue(f"Forward traffic from https://<node>.{fqdn}:{nginx_app_port} to http://localhost:{sa_app_port}") >> elements["superalgos"]
        elements["nginx"] >> solidGreen(f"Forward traffic from https://<node>.{fqdn}:{nginx_ws_port} to http://localhost:{sa_ws_port}") >> elements["superalgos"]


def managementTrafficFlow(environment, region, fqdn, out_dir: str = '.', graph_attr = {}):
    with Diagram("Superalgos IaC - Management Traffic", filename=f"{out_dir}/diagram-management-{environment}-{region}", outformat="png", show=False, graph_attr=graph_attr):
        elements = {}
        managementInfrastructure(elements=elements, region=region, fqdn=fqdn)
        # User -> SSH Managment traffic flow
        elements["user"] >> solidRed(f"1: Establish Client VPN") >> elements["internet"] >> solidRed(f"1: Establish Client VPN") >> elements["vpn_endpoint"] >> solidRed(f"1: Establish Client VPN") >> elements["vpn_connection"]
        elements["vpn_connection"] >> solidRed(f"2: SSH to Bastion Host :: ssh://<bastion>.{fqdn}:{ssh_port}") >> elements["bastion"]
        elements["bastion"] >> solidRed(f"3: SSH from Bastion to Superalgos Nodes :: ssh://<instance>.{fqdn}:{ssh_port}") >> elements["app_instances"]
        # Application egress for updates
        elements["app_instances"] >> solidBlue("4: Outbout Internet Traffic") >> elements["ngw_sa_nodes"] >> solidBlue("4: Outbout Internet Traffic") >> elements["igw"]
        elements["bastion"] >> solidBlue("4: Outbout Internet Traffic") >> elements["ngw_bastion"] >> solidBlue("4: Outbout Internet Traffic") >> elements["igw"]
        elements["igw"] >> solidBlue("4: Outbout Internet Traffic") >> elements["internet"]
        # Bastion Access Logs
        elements["bastion"] >> dashedRed("5: Access Logs :: Bastion") >> elements["cloud_watch"] >> dashedRed("6: Access Logs Read-Only Storage :: Bastion") >> elements["s3_bastion"]
        # VPN Access Logs
        elements["vpn_endpoint"] >> dashedRed("5: Access Logs :: VPN Client") >> elements["cloud_watch"] >> dashedRed("6: Access Logs Read-Only Storage :: VPN Client") >> elements["s3_vpnlogs"]


def managementInfrastructure(elements, region, fqdn):
    awsAccount(elements)
    with elements["aws_account_cluster"]:
        elements["region"] = Cluster(f"Region: {region}")
        with elements["region"]:
            elements["cloud_watch"] = Cloudwatch("AWS Cloudwatch")
            elements["s3_bastion"] = S3(f"bastion-logs.{fqdn}")
            elements["s3_vpnlogs"] = S3(f"vpn-logs.{fqdn}")
            elements["vpn_endpoint"] = ClientVpn(f"{vpn_subdomain}.{fqdn}")
            elements["vpc_sa"] = Cluster(f"Superalgos VPC :: {vpc_cidr}")
            #
            with elements["vpc_sa"]:
                elements["subnet_application"] = Cluster(f"Application Subnet :: {application_subnet_cidr}")
                elements["subnet_bastion"] = Cluster(f"Bastion Subnet :: {bastion_subnet_cidr}")
                elements["subnet_public"] = Cluster(f"Public Subnet :: {public_subnet_cidr}")
                elements["subnet_vpn"] = Cluster(f"VPN Subnet :: {vpn_subnet_cidr}")
                # Public Subnet Objectes
                with elements["subnet_public"]:
                    elements["igw"] = InternetGateway("igw")
                # Bastion Subnet Object
                with elements["subnet_bastion"]:
                    elements["ngw_bastion"] = NATGateway("NatGW: Bastion Subnets")
                    elements["sg_bastion"] = Cluster("SG: Bastion")
                    with elements["sg_bastion"]:
                        elements["bastion"] = EC2("Bastion Host")
                # Application Subnet Object
                with elements["subnet_application"]:
                    elements["ngw_sa_nodes"] = NATGateway("NatGW: SA Nodes")
                    elements["sg_sa_nodes"] = Cluster("SG: Superalgos Nodes")
                    elements["sg_internal_lb"] = Cluster("SG: Internal LB")
                    # SG: Internal LB Object
                    with elements["sg_internal_lb"]:
                        elements["internal_lb"] = ALB("Internal ALB")
                    # SG: SA Nodes Object
                    with elements["sg_sa_nodes"]:
                        elements["app_instances"] = [
                            saInstance(f"{i.get('idx')}.{fqdn}")
                            for i in sa_instance_mapping
                        ]
                # VPN Subnet Object
                with elements["subnet_vpn"]:
                    elements["vpn_connection"] = VpnConnection("Client VPN Connection")
            # Add connections from each SA Node to an EBS Volume
            for idx, i in enumerate(sa_instance_mapping):
                elements["app_instances"][idx] - ElasticBlockStoreEBSVolume(f"sa_ebs_{i.get('idx')}")

#


def makeDiagrams(out_dir: str = '.'):
    graph_attr = {
        "fontsize": "45",
    }
    for environment, region in zip(environments, regions):
        # The fully qualified domain name that will be appended
        fqdn = f"{environment}.{sa_subdomain}.{region}.{sa_TLD}"
        # ################
        # Overview Diagram
        # ################
        authTrafficFlow(environment=environment, region=region, fqdn=fqdn, out_dir=out_dir, graph_attr=graph_attr)

        # Management Traffic
        managementTrafficFlow(environment=environment, region=region, fqdn=fqdn, out_dir=out_dir, graph_attr=graph_attr)

        # Node Diagram
        superalgosNodeDiagram(environment=environment, region=region, fqdn=fqdn, out_dir=out_dir, graph_attr=graph_attr)
    






class ArgumentParser(argparse.ArgumentParser):
    def error(self, message):
        sys.stderr.write("error: %s" % message)
        self.print_help()
        sys.exit(2)


def build_program_parser() -> ArgumentParser:
    """
    Parse program arguments
    Usage:
        args = program_arguments()
    """

    # Main parser
    parser = ArgumentParser(
        description="Generate Architecture Diagrams",
        exit_on_error=True,
        formatter_class=argparse.RawTextHelpFormatter,
    )

    parser.add_argument(
        "-d",
        "--debug",
        action="store_true",
        default=False,
        help="Increase logging verbosity to debug",
    )

    parser.add_argument(
        "-o",
        "--output",
        action="store",
        default=".",
        dest="directory",
        help="The directory to output the generated diagram files",
    )

    return parser


def main(args: argparse.Namespace) -> None:
    """
    Main program logic
    """
    makeDiagrams(out_dir=args.directory)


if __name__ == "__main__":
    parser = build_program_parser()
    args = parser.parse_args()
    main(args)



