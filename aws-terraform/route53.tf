data "aws_route53_zone" "hosted_zone" {
  name = "thetechvoyager.in"
  private_zone = false
}

resource "aws_route53_record" "quest-route53_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name = "quest"
  type = "A"
  alias {
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}