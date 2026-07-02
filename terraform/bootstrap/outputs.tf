output "dev_bucket_name" {
  value = aws_s3_bucket.dev_tfstate_bucket.id
}

output "staging_bucket_name" {
  value = aws_s3_bucket.staging_tfstate_bucket.id
}

output "prod_bucket_name" {
  value = aws_s3_bucket.prod_tfstate_bucket.id
}
