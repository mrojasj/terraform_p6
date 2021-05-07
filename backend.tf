#backend configuration

terraform {
  backend "s3" {
    bucket = "terraform-tfstate-bucket-michaelrojas"
    key    = "state/p6/terraform.tfstate"
    region = "us-east-1"
  }
}
