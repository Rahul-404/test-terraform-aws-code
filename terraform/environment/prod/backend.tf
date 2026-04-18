terraform {
  backend "s3" {
    bucket       = "tf-prod-bucket-rahul-2026"
    key          = "prod/terraform.state"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
