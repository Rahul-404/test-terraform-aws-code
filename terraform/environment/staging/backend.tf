terraform {
  backend "s3" {
    bucket       = "tf-staging-bucket-rahul-2026"
    key          = "staging/terraform.state"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
