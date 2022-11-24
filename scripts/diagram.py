from __future__ import annotations

import argparse
import sys

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.general import InternetGateway
from diagrams.aws.management import AutoScaling
from diagrams.aws.network import ALB, ClientVpn
from diagrams.aws.security import Cognito
from diagrams.aws.storage  import ElasticBlockStoreEBSVolume
from diagrams.onprem.client import User
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

# Set this to the subdomain of the vpn
# vpn_subdomain = "vpn"
vpn_subdomain = "vpn"


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


def solidGreen(label="", color="darkgreen", style=""):
    return Edge(label=label, color=color, style=style)


def solidRed(label="", color="firebrick", style="solid"):
    return Edge(label=label, color=color, style=style)



def makeDiagrams(out_dir: str = '.'):
    for environment, region in zip(environments, regions):
        fqdn = f"{environment}.{sa_subdomain}.{region}.{sa_TLD}"
        with Diagram("Superalgos IaC", filename=f"{out_dir}/diagram-{environment}-{region}", outformat="png"):
            user = User("User")
            
            #
            with Cluster(f"AWS Account: {aws_account_alias}"):
                    with Cluster(f"Region: {region}"):
                        cognito = Cognito("AWS Cognito")
                        vpn_endpoint = ClientVpn(f"{vpn_subdomain}.{fqdn}")
                        #
                        with Cluster("Superalgos VPC"):
                            subnet_application = Cluster("Application Subnet")
                            subnet_bastion = Cluster("Bastion Subnet")
                            subnet_public = Cluster("Public Subnet")

                            with subnet_public:
                                igw = InternetGateway("igw")
                                sg_alb = Cluster("SG: ALB")
                                with sg_alb:
                                    external_lb = ALB("Internet-Facing ALB")
                                    
                            #
                            with subnet_bastion:
                                sg_bastion = Cluster("SG: Bastion")
                                with sg_bastion:
                                    bastion = EC2("Bastion Host")
                            #
                            with subnet_application:
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
                            print(idx)
                            app_instances[idx] - ElasticBlockStoreEBSVolume(f"sa_ebs_{i.get('idx')}")
            #
            user >> dashedRed(f"https://{environment}.{sa_subdomain}.{sa_TLD}:{sa_tls_port}") >> igw >> dashedRed() >> external_lb

            external_lb >> solidRed("Authenticate and Authorize User") >> cognito 
            cognito >> dottedGreen("Authorized") >> external_lb

            external_lb >> boldGreen("Authorized Responses") >> igw >> boldGreen("Authorized Responses") >> user



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



