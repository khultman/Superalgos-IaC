
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket                        = "CHANGE-THE-BUCKET-NAME"
    key                           = "global/100-Cognito/terraform.tfstate"
    region                        = "CHANGE-THE-REGION"

    # Replace this with your DynamoDB table name!
    dynamodb_table                = "CHANGE-THE-TABLE-NAME"
    encrypt                       = true
  }
}