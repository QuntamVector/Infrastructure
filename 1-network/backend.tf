# terraform {
#   backend "s3" {
#     bucket         = "laxmanraju-state-lock"
#     key            = "laxmanraju/1-network/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "laxmanraju-state-DB-1-lock"
#     encrypt        = true
#   }
# }

terraform {
  backend "s3" {
    bucket        = "laxmanraju-state-lock"   # your S3 bucket
    key           = "env/terraform.tfstate"   # path inside the bucket
    region        = "us-east-1"
    encrypt       = true
    use_lockfile  = true                      # replaces dynamodb_table
  }
}