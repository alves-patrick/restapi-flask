# Criar a Hosted Zone no Route 53
resource "aws_route53_zone" "main" {
  name = "restapi-flask.xyz"

  tags = var.tags
}

# Criar o Certificado SSL no ACM
resource "aws_acm_certificate" "cert" {
  domain_name       = "restapi-flask.xyz"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.restapi-flask.xyz"
  ]

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Registro DNS para validação do Certificado
resource "aws_route53_record" "cert_validation" {
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
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

# Validação do Certificado (Aguarda a propagação)
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
