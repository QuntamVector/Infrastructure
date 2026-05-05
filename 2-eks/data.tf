data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "laxmanraju-statefile-logs"
    key    = "env/terraform.tfstate"
    region = "us-east-1"
  }
}
