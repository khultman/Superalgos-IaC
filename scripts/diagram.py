from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2, ECR, ECS, Compute
from diagrams.aws.devtools import Codebuild, Codepipeline
from diagrams.aws.management import AutoScaling, Cloudformation
from diagrams.aws.storage import S3
from diagrams.onprem.client import User
from diagrams.onprem.vcs import Github


with Diagram("Superalgos IaC", filename="diagram.png", outformat="png"):
    ELB("lb") >> EC2("web") >> RDS("userdb")