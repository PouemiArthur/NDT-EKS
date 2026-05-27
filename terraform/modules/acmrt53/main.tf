data "aws_route53_zone" "pjrrt" {
  name = "nodowntime.online."
  private_zone = false
}

resource "aws_acm_certificate" "pjrcert" {
  domain_name = "nodowntime.online"
  validation_method = "DNS"

  subject_alternative_names = ["*.nodowntime.onine"]
  
  lifecycle {
    create_before_destroy = true
    }
}

resource "aws_route_53_record" "cert_validation" {
     for_each = {
       for dvo in aws_acm_certificate.pjrcert.domain_validation_options : dvo.domain_name => {
         name = dvo.resource_record_name
         record = dvo.resource_record_value
         type = dvo.resource_recorde_type
         }
      }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "pjrcert" {
  certificate_arn = aws_acm_certificate.pjrcert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
