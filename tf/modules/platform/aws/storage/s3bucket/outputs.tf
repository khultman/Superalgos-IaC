
output "s3_bucket_id" {
  description                     = "The name of the bucket."
  value                           = try(aws_s3_bucket_policy.s3bucket-policy.id, aws_s3_bucket.s3bucket.id, "")
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(aws_s3_bucket.s3bucket.arn, "")
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = try(aws_s3_bucket.s3bucket.bucket_domain_name, "")
}