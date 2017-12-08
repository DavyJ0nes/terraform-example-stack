# ELB Module Outputs
# Davy Jones
# Cloudreach

output "elb_id" {
  value = "${aws_elb.elb.id}"
}

output "elb_name" {
  value = "${aws_elb.elb.name}"
}

output "elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "web_elb_sg" {
  value = "${aws_security_group.web_elb.id}"
}

output "elb_zone_id" {
  value = "${aws_elb.elb.zone_id}"
}
