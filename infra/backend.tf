########################################################
# Terraform S3 Backend & DynamoDB Lock
########################################################
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-djshfjsdbh"    # CHANGE to your S3 bucket name
    key            = "weatherapp-eks/terraform.tfstate"
    region         = "us-east-1"                    # CHANGE to your region
    dynamodb_table = "my-terraform-lock-table-dfhsjdf"      # CHANGE to your DynamoDB table name
    encrypt        = true
  }
}
