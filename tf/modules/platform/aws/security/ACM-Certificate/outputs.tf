
output "certificate_arn" {
  description                     = "The ARN of the certificate"
  value                           = aws_acm_certificate.cert.arn
}

output "certificate_domain_name" {
  description                     = "The domain name for which the certificate was requested"
  value                           = aws_acm_certificate.cert.domain_name
}


output "certificate_validation_arns" {
  description                     = "The ARNs of the validation records"
  value                           = aws_acm_certificate.cert.validation_arns
}

output "certificate_status" {
  description                     = "The status of the certificate"
  value                           = aws_acm_certificate.cert.status
}

output "certificate_issued_at" {
  description                     = "The time at which the certificate was issued"
  value                           = aws_acm_certificate.cert.issued_at
}

output "certificate_issuer" {
  description                     = "The certificate authority that issued the certificate"
  value                           = aws_acm_certificate.cert.issuer
}

output "certificate_subject" {
  description                     = "The certificate subject"
  value                           = aws_acm_certificate.cert.subject
}

output "certificate_not_before" {
  description                     = "The time before which the certificate is not valid"
  value                           = aws_acm_certificate.cert.not_before
}

output "certificate_not_after" {
  description                     = "The time after which the certificate is not valid"
  value                           = aws_acm_certificate.cert.not_after
}

output "certificate_key_algorithm" {
  description                     = "The algorithm used to generate the key pair"
  value                           = aws_acm_certificate.cert.key_algorithm
}

output "certificate_signature_algorithm" {
  description                     = "The algorithm used to sign the certificate"
  value                           = aws_acm_certificate.cert.signature_algorithm
}

output "certificate_in_use_by" {
  description                     = "The ARNs of the AWS resources that are using the certificate"
  value                           = aws_acm_certificate.cert.in_use_by
}

output "certificate_domain_validation_options" {
  description                     = "The domain validation options"
  value                           = aws_acm_certificate.cert.domain_validation_options
}

output "certificate_serial" {
  description                     = "The serial number of the certificate"
  value                           = aws_acm_certificate.cert.serial
}

output "certificate_subject_alternative_names" {
  description                     = "The subject alternative names (SANs) included in the certificate"
  value                           = aws_acm_certificate.cert.subject_alternative_names
}

output "certificate_type" {
  description                     = "The type of the certificate"
  value                           = aws_acm_certificate.cert.type
}

output "certificate_created_at" {
  description                     = "The time at which the certificate was requested"
  value                           = aws_acm_certificate.cert.created_at
}

output "certificate_options" {
  description                     = "The options for the certificate"
  value                           = aws_acm_certificate.cert.options
}


output "certificate_validation_method" {
  description                     = "The method used to validate the certificate"
  value                           = aws_acm_certificate.cert.validation_method
}

