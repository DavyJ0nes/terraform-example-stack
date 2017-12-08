# Auto Scaling Group Module
# Davy Jones
# Cloudreach

#----------- GET GOLDEN AMI ID ----------#

data "aws_ami" "packer_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_search_term}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#----------- SET UP ASG SECURITY GROUP ----------#
resource "aws_security_group" "asg" {
  name        = "${var.prefix}-${var.env}-${var.layer}-asg-sg"
  vpc_id      = "${var.vpc_id}"
  description = "ASG Security Group"

  tags {
    Name  = "${var.prefix}-${var.env}-${var.layer}-asg-sg"
    Owner = "${var.owner}"
  }

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    security_groups = ["${var.in_security_group_ids}"]
  }

  ingress {
    from_port       = "443"
    to_port         = "443"
    protocol        = "tcp"
    security_groups = ["${var.in_security_group_ids}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------- SET UP LAUNCH CONFIG ----------#

resource "aws_launch_configuration" "asg_lc" {
  name_prefix          = "${var.prefix}-${var.env}-${var.layer}-lc"
  image_id             = "${data.aws_ami.packer_image.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${var.instance_profile}"
  security_groups      = ["${aws_security_group.asg.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

#----------- SET UP AUTOSCALING GROUP ----------#

resource "aws_autoscaling_group" "asg" {
  name              = "${var.prefix}-${var.env}-${var.layer}-asg"
  max_size          = "${var.max_size}"
  min_size          = "${var.min_size}"
  health_check_type = "ELB"
  enabled_metrics   = ["GroupInServiceInstances", "GroupPendingInstances", "GroupDesiredCapacity", "GroupTerminatingInstances", "GroupTotalInstances"]
  desired_capacity  = "${var.desired_capacity}"

  # force_delete         = true
  launch_configuration = "${aws_launch_configuration.asg_lc.name}"
  load_balancers       = ["${var.elb_name}"]
  vpc_zone_identifier  = ["${split(",", var.subnets)}"]

  depends_on = ["aws_launch_configuration.asg_lc"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-${var.env}-${var.layer}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "${var.owner}"
    propagate_at_launch = true
  }
}

#----------- SET UP AUTOSCALING POLICY ----------#

resource "aws_autoscaling_policy" "policy" {
  name                   = "${var.prefix}-${var.env}-${var.layer}-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

#----------- SET UP CW METRIC ALARM ----------#

resource "aws_cloudwatch_metric_alarm" "asg-alarm" {
  alarm_name          = "${var.prefix}-${var.env}-${var.layer}-asg-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.policy.arn}", "${var.sns_arn}"]
}
