terraform {
  backend "s3" {
    bucket         = "quantamvector-infra-statefile-backup-1"
    key            = "quantamvector/1-network/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "quantamvector-terraform-locks"
    encrypt        = true
  }
}
