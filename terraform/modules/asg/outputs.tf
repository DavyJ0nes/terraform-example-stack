# Auto Scaling Group Module
# Davy Jones
# Cloudreach

output "asg_name" {
  value = "${aws_autoscaling_group.asg.name}"
}

output "asg_security_group_name" {
  value = "${aws_security_group.asg.name}"
}

output "asg_security_group_id" {
  value = "${aws_security_group.asg.id}"
}
