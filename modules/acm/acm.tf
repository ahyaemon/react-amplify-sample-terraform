resource "aws_acm_certificate" "cert" {
  domain_name       = "todo.ahyaemon.com"
  validation_method = "DNS"
}
