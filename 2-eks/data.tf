data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "quantamvector-infra-statefile-backup-1"
    key    = "quantamvector/1-network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
