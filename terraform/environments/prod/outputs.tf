# Dev Stack - Outputs
# Davy Jones
# Cloudreach

output "elb_address" {
  value = "${module.web_elb.elb_dns_name}"
}

output "domain_name" {
  value = "${module.dns.dns_name}"
}
