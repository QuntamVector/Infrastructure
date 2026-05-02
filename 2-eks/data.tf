data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "quantamvector-infra-statefile-backups"
    key    = "quantamvector/1-network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
