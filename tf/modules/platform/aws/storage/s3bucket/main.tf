
resource "aws_s3_bucket" "s3bucket" {
  bucket                          = var.bucket
  bucket_prefix                   = var.bucket_prefix
  force_destroy                   = var.force_destroy
  object_lock_enabled             = var.object_lock_enabled
  tags                            = merge(var.tags, lookup(var.tags_for_resource, "aws_vpc", {}))
}

resource "aws_s3_bucket_acl" "s3bucket_acl" {
  bucket                          = aws_s3_bucket.s3bucket.id
  expected_bucket_owner           = var.expected_bucket_owner

  # hack when `null` value can't be used (eg, from terragrunt, https://github.com/gruntwork-io/terragrunt/pull/1367)
  acl                             = var.acl == "null" ? null : var.acl

  dynamic "access_control_policy" {
    for_each = length(local.grants) > 0 ? [true] : []

    content {
      dynamic "grant" {
        for_each = local.grants

        content {
          permission = grant.value.permission

          grantee {
            type          = grant.value.type
            id            = try(grant.value.id, null)
            uri           = try(grant.value.uri, null)
            email_address = try(grant.value.email, null)
          }
        }
      }

      owner {
        id           = try(var.owner["id"], data.aws_canonical_user_id.this.id)
        display_name = try(var.owner["display_name"], null)
      }
    }
  }
}