# VPC Module
# Davy Jones
# Cloudreach
output "vpc_id" {
  value = "${aws_vpc.env.id}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_subnet_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
}
