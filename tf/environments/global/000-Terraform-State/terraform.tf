
# Before you plan and apply the global environment, please comment out the
# terraform configuration below.
#
# Once you have created the S3 buckets, you can uncomment this configuration
# and change the bucket and dynamo settings to match the created resources.
# After you have made the appropriate changes, you will need to perform
# `terraform init` again to point to the remote state bucket. Once you have
# done that, simply apply this environment again before moving to the next
# steps in the deployment.

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket                        = "CHANGE-THE-BUCKET-NAME"
    key                           = "global/000-Terraform-State/terraform.tfstate"
    region                        = "CHANGE-THE-REGION"

    # Replace this with your DynamoDB table name!
    dynamodb_table                = "CHANGE-THE-TABLE-NAME"
    encrypt                       = true
  }
}

