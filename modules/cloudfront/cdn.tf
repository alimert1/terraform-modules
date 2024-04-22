resource "aws_s3_bucket" "bucket_01" {
  bucket = "${var.project}-media"

  tags = {
    Name      = "${var.project}-media"
  }
}

# resource "aws_s3_bucket_ownership_controls" "bucket_01" {
#   bucket = aws_s3_bucket.bucket_01.id

#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }

# resource "aws_s3_bucket_acl" "bucket_01" {
#   depends_on = [aws_s3_bucket_ownership_controls.bucket_01]

#   bucket = aws_s3_bucket.bucket_01.id
#   acl    = "private"
# }

resource "aws_s3_bucket_policy" "bucket_01" {
  bucket = aws_s3_bucket.bucket_01.bucket

  policy = jsonencode(
    {
      Id = "PolicyForCloudFrontPrivateContent"
      Statement = [
        {
          Action = "s3:GetObject"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai_01.id}"
          }
          Resource = "arn:aws:s3:::${aws_s3_bucket.bucket_01.bucket}/*"
          Sid      = "1"
        },
      ]
      Version = "2008-10-17"
    }
  )
}

##########################################################################################
##########################################################################################


locals {
  s3_origin_id_01 = aws_s3_bucket.bucket_01.bucket_regional_domain_name
}



resource "aws_cloudfront_origin_access_identity" "oai_01" {
  comment = "${var.project}-media"
}



resource "aws_cloudfront_distribution" "cdn_01" {
  origin {
    domain_name = local.s3_origin_id_01
    origin_id   = local.s3_origin_id_01

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai_01.cloudfront_access_identity_path
    }
  }

  aliases = [var.aliases]
  comment = var.aliases

  default_cache_behavior {
    allowed_methods = ["GET",
    "HEAD"]

    cached_methods = ["GET",
    "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    target_origin_id       = local.s3_origin_id_01
    viewer_protocol_policy = "redirect-to-https"

  }

  enabled          = true
  http_version     = "http2"
  price_class      = "PriceClass_100"
  retain_on_delete = false

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  wait_for_deployment = false
}