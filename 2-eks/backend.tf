terraform {
  backend "s3" {
    bucket         = "laxmanraju-state-1-lock"
    key            = "laxmanraju/2-eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "laxmanraju-state-DB-1-lock"
    encrypt        = true
  }
}
