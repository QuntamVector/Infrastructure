terraform {
  backend "s3" {
    bucket         = "laxmanraju-state-lock"
    key            = "laxmanraju/1-network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "laxmanraju-state-DB-1-lock"
    encrypt        = true
  }
}
