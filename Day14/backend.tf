terraform {
  backend "s3" {
    bucket       = "muntaha-tf-modules-state-file"
    key          = "prod01/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}