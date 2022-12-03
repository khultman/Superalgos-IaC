# Environment: Global

This environment focuses on providing the global resources necessary for
managing the state files of terraform.

## Usage

**First:** Edit `terraform.tf` to comment out the remote state configuration.

**Second:** Edit `main.tf` to edit the bucket and dynamodb names.

**Third:** Run `terraform init && terraform plan && terraform apply`

**Fourth:** Edit `terraform.tf` to uncomment the remote state configuration. Change the bucket and dynamodb names to match `main.tf`

**Fifth:** Run `terraform init && terraform plan && terraform apply` to initialize the remote state and copy the locally generated state to S3.


You are now ready to move to the phase of deployment.
