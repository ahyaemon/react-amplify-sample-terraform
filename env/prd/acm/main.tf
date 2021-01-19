module "acm" {
  source = "../../../modules/acm"
}

output "acm_certificate_arn" {
  value = module.acm.acm_certificate_arn
}
