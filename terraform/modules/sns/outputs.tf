# SNS Module Outputs
# Davy Jones
# Cloudreach

output "sns_topic_arn" {
  value = "${aws_sns_topic.env.arn}"
}
