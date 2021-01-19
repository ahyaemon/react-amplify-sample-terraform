resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_identity" {

}

locals {
  s3_origin_id = "frontendS3Origin"
}

variable "acm_certificate_arn" {}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    cloudfront_default_certificate = false
    ssl_support_method = "sni-only"
  }
  aliases = ["todo.ahyaemon.com"]

  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/"
  }

}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}

resource "aws_route53_record" "record" {
  zone_id = "Z07475891D00S6Q5AB6S"
  name    = "todo.ahyaemon.com"
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    evaluate_target_health = false
    zone_id = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
  }
}
