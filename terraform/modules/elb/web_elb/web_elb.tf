# ELB Module
# Davy Jones
# Cloudreach

#--------- CREATE WEB ELB SECURITY GROUP ---------#
resource "aws_security_group" "web_elb" {
  name        = "${var.prefix}-${var.env}-${var.layer}-elb-sg"
  vpc_id      = "${var.vpc_id}"
  description = "Web ELB Security Group"

  tags {
    Name  = "${var.prefix}-${var.env}-${var.layer}-elb-sg"
    Owner = "${var.owner}"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#---------- GET CERTIFICATE ARN ----------#

data "aws_acm_certificate" "domain" {
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}

#---------- ACCESS LOGS S3 BUCKET ----------#
resource "aws_s3_bucket" "elb_access_logs" {
  bucket = "${var.prefix}-${var.env}-${var.layer}-elb-access-logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::156460612806:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.prefix}-${var.env}-${var.layer}-elb-access-logs/*"
    }
  ]
}
EOF

  tags {
    Name  = "${var.prefix}-${var.env}-${var.layer}-elb-access-logs"
    Owner = "${var.owner}"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

#--------- ELB ---------#
resource "aws_elb" "elb" {
  name            = "${var.prefix}-${var.env}-${var.layer}-elb"
  subnets         = ["${split(",", var.subnets)}"]
  security_groups = ["${aws_security_group.web_elb.id}"]
  internal        = "${var.internal}"

  access_logs {
    bucket        = "${aws_s3_bucket.elb_access_logs.bucket}"
    bucket_prefix = "${var.prefix}-${var.env}-${var.layer}-elb"
    interval      = 60
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.domain.arn}"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    target              = "HTTP:80/status"
    interval            = 10
  }

  connection_draining         = true
  connection_draining_timeout = 250

  tags {
    Name  = "${var.prefix}-${var.env}-${var.layer}-elb"
    Owner = "${var.owner}"
  }
}
