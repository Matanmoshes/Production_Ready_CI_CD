terraform {
  backend "s3" {
    bucket         = "production-env-state-v3-jsdhfjs"       
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"  
    encrypt        = true
  }
}
