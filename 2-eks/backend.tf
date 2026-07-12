terraform {
  backend "s3" {
    bucket         = "quantamvector-infra-statefile-backup-1"
    key            = "quantamvector/2-eks/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "quantamvector-terraform-locks"
    encrypt        = true
  }
}
