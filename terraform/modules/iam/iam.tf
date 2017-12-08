# IAM Module
# Davy Jones
# Cloudreach

#---------- EC2 ROLE ----------#
resource "aws_iam_role" "role" {
  name        = "${var.prefix}-${var.env}-iam-role"
  description = "Owner: ${var.owner}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "role_policy" {
  name = "${var.prefix}-${var.env}-iam-role-policy"
  role = "${aws_iam_role.role.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#---------- EC2 INSTANCE PROFILE ----------#
resource "aws_iam_instance_profile" "profile" {
  name = "${var.prefix}-${var.env}-iam-profile"
  role = "${aws_iam_role.role.name}"
}
