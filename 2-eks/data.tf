data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "laxmanraju-statefile-logs"
    key    = "laxmanraju/1-network/terraform.tfstate"
    region = "us-east-1"
  }
}
