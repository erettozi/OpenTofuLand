resource "aws_route53_record" "api_record" {
  zone_id = var.zone_id
  name    = var.api_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.api_alb.dns_name
    zone_id                = aws_lb.api_alb.zone_id
    evaluate_target_health = true
  }
}