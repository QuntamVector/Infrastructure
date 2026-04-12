data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "laxmanraju-state-lock"
    key    = "laxmanraju/1-network/terraform.tfstate"
    region = "us-east-1"
  }
}
