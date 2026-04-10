terraform {
  backend "s3" {
    bucket         = "quantamvector-infra-statefile-backup"
    key            = "quantamvector/1-network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "quantamvector-terraform-locks"
    encrypt        = true
  }
}
