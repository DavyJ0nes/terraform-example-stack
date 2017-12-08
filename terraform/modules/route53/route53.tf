# Route53 Module
# Davy Jones
# Cloudreach

resource "aws_route53_zone" "env" {
  name = "${var.domain_name}"

  tags {
    Name  = "${var.prefix}-route53-zone"
    Owner = "${var.owner}"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_route53_record" "env" {
  zone_id = "${aws_route53_zone.env.id}"
  name    = "${var.env}"
  type    = "A"

  alias {
    name                   = "${var.elb_name}"
    zone_id                = "${var.elb_zone_id}"
    evaluate_target_health = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}
