# route53.tf
resource "aws_route53_record" "strapi" {
  zone_id = "Z06607023RJWXGXD2ZL6M"  # Replace with your Route 53 hosted zone ID
  name    = "togaruashok1996.contentecho.in"  # Replace with your subdomain
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = false
  }

  lifecycle {
    create_before_destroy = true
  }
}
