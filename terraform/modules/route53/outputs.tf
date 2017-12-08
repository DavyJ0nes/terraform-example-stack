# Route 53 Module
# Davy Jones
# Cloudreach

output "zone_id" {
  value = "${aws_route53_zone.env.id}"
}

output "dns_name" {
  value = "${aws_route53_zone.env.name}"
}
