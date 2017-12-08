# Bastion Host Module Outputs
# Davy Jones
# Cloudreach

output "bastion_host_dns" {
  value = "${aws_instance.bastion.public_dns}"
}

output "bastion_host_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "bastion_sg" {
  value = "${aws_security_group.bastion.id}"
}
