from __future__ import annotations

import argparse
import sys

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.general import InternetGateway
from diagrams.aws.management import AutoScaling, Cloudwatch
from diagrams.aws.network import ALB, ClientVpn, NATGateway
from diagrams.aws.security import Cognito
from diagrams.aws.storage  import ElasticBlockStoreEBSVolume, S3
from diagrams.onprem.client import User
from diagrams.onprem.network import Internet
from diagrams.onprem.vcs import Github


# Set this to the name or ID of your AWS account
# aws_account_alias = "Superalgos"
aws_account_alias = "Superalgos"

# Set this to the name of the environment
# environments = ["live", "paper"]
environments = ["paper"]


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
sa_tls_port = 443

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
        "tls_port": f"8{sa_tls_port + i}",
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


def solidBlue(label="", color="darkblue", style=""):
    return Edge(label=label, color=color, style=style)

def solidGreen(label="", color="darkgreen", style=""):
    return Edge(label=label, color=color, style=style)


def solidRed(label="", color="firebrick", style="solid"):
    return Edge(label=label, color=color, style=style)



def makeDiagrams(out_dir: str = '.'):
    for environment, region in zip(environments, regions):
        # The fully qualified domain name that will be appended
        fqdn = f"{environment}.{sa_subdomain}.{region}.{sa_TLD}"
        # ################
        # Overview Diagram
        # ################
        with Diagram("Superalgos IaC", filename=f"{out_dir}/diagram-{environment}-{region}", outformat="png"):
            internet = Internet("Public Internet")
            user = User("User")
            #
            with Cluster(f"AWS Account: {aws_account_alias}"):
                    with Cluster(f"Region: {region}"):
                        cloud_watch = Cloudwatch("AWS Cloudwatch")
                        cognito = Cognito("AWS Cognito")
                        s3_access = S3(f"access-logs.{fqdn}")
                        s3_bastion = S3(f"bastion-logs.{fqdn}")
                        vpn_endpoint = ClientVpn(f"{vpn_subdomain}.{fqdn}")
                        #
                        with Cluster(f"Superalgos VPC :: {vpc_cidr}"):
                            subnet_application = Cluster(f"Application Subnet :: {application_subnet_cidr}")
                            subnet_bastion = Cluster(f"Bastion Subnet :: {bastion_subnet_cidr}")
                            subnet_public = Cluster(f"Public Subnet :: {public_subnet_cidr}")

                            with subnet_public:
                                igw = InternetGateway("igw")
                                sg_alb = Cluster("SG: ALB")
                                with sg_alb:
                                    external_lb = ALB("Internet-Facing ALB")
                                    external_lb >> cloud_watch >> dashedRed("ALB Access Logs") >> s3_access
                                    
                            #
                            with subnet_bastion:
                                ngw_bastion = NATGateway("NatGW: Bastion Subnets")
                                sg_bastion = Cluster("SG: Bastion")
                                with sg_bastion:
                                    bastion = EC2("Bastion Host")
                                    bastion >> cloud_watch >> dashedRed("Bastion Logs") >> s3_bastion
                            #
                            with subnet_application:
                                ngw_sa_nodes = NATGateway("NatGW: SA Nodes")
                                sg_sa_nodes = Cluster("SG: SA Nodes")
                                sg_internal_lb = Cluster("SG: Internal LB")

                                with sg_internal_lb:
                                    internal_lb = ALB("Internal ALB")

                                with sg_sa_nodes:
                                    app_instances = [
                                        saInstance(f"{i.get('idx')}.{fqdn}")
                                        for i in sa_instance_mapping
                                    ]
                                    # app_instances - app_ebs_volumes
                                
                                app_instances[0] >> solidGreen(f"Internal unsecured WS and HTTP Communication:\n`ws://{fqdn}:{sa_ws_port}[+NodeIndex]`\n`http://{fqdn}:{sa_app_port}[+NodeIndex]`") >> internal_lb
                                internal_lb >> solidGreen(f"Internal traffic hairpin") >> app_instances[-1]
                        #
                        for idx, i in enumerate(sa_instance_mapping):
                            app_instances[idx] - ElasticBlockStoreEBSVolume(f"sa_ebs_{i.get('idx')}")
            #
            user >> dashedRed(f"https://{fqdn}") >> internet >> dashedRed() >> igw >> dashedRed() >> external_lb

            external_lb >> solidRed("Authenticate and Authorize User") >> cognito 
            cognito >> dottedGreen("Authorized") >> external_lb

            external_lb >> boldGreen("Authorized Responses") >> igw >> boldGreen() >> internet >> boldGreen("Authorized Responses") >> user

            external_lb >> solidGreen("Authenticated Traffic") >> app_instances

            user >> solidRed(f"Establish Client VPN") >> internet >> solidRed() >> vpn_endpoint
            vpn_endpoint >> solidRed(f"ssh://<bastion>.{fqdn}:{ssh_port}") >> bastion
            bastion >> solidRed(f"ssh://<instance>.{fqdn}:{ssh_port}") >> app_instances

            app_instances >> solidBlue("Outbout Internet Traffic") >> ngw_sa_nodes >> solidBlue() >> igw >> solidBlue() >> internet
            bastion >> solidBlue("Outbout Internet Traffic") >> ngw_bastion >> solidBlue() >> igw >> solidBlue() >> internet




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



