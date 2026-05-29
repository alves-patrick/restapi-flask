output "nameservers" {
  value = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
