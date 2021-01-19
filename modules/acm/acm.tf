resource "aws_acm_certificate" "cert" {
  domain_name       = "todo.ahyaemon.com"
  validation_method = "DNS"
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

resource "aws_route53_zone" "zone" {
  name = "todo.ahyaemon.com"
}

resource "aws_route53_record" "record" {
  for_each = {
  for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}
