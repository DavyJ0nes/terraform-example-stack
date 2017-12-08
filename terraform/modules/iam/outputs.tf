# IAM Module Outputs
# Davy Jones
# Cloudreach

output "instance_profile" {
  value = "${aws_iam_instance_profile.profile.name}"
}
