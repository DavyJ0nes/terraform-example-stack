# Cloudwatch Module
# Davy Jones
# Cloudreach

#---------- CREATE CLOUDWATCH DASHBOARD ----------#
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${var.prefix}-${var.env}-Dashboard"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "text",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "\n# AgileOps Training | ${title(var.env)} Dashboard\n"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 8,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "\n## Web ASG\n"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 12,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.prefix}-${var.env}-asg" ]
                ],
                "region": "eu-west-1"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 9,
            "width": 12,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "NetworkPacketsOut", "AutoScalingGroupName", "${var.prefix}-${var.env}-asg", { "yAxis": "right" } ],
                    [ ".", "NetworkPacketsIn", ".", ".", { "yAxis": "right" } ],
                    [ ".", "NetworkIn", ".", "." ],
                    [ ".", "NetworkOut", ".", "." ]
                ],
                "region": "eu-west-1",
                "title": "Network IO"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 1,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "\n## Web ELB\n"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 2,
            "width": 3,
            "height": 3,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "AWS/ELB", "HealthyHostCount", "LoadBalancerName", "${var.prefix}-${var.env}-web-elb", { "stat": "Average" } ]
                ],
                "region": "eu-west-1",
                "period": 300,
                "title": "Healthy Hosts"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 5,
            "width": 3,
            "height": 3,
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "AWS/ELB", "HealthyHostCount", "LoadBalancerName", "${var.prefix}-${var.env}-web-elb", { "stat": "Average" } ]
                ],
                "region": "eu-west-1",
                "period": 300,
                "title": "Healthy Hosts"
            }
        },
        {
            "type": "metric",
            "x": 3,
            "y": 2,
            "width": 9,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/ELB", "Latency", "LoadBalancerName", "${var.prefix}-${var.env}-web-elb", { "stat": "Average", "yAxis": "left" } ],
                    [ "...", { "stat": "p50", "yAxis": "left" } ],
                    [ "...", { "stat": "p90", "yAxis": "left" } ]
                ],
                "region": "eu-west-1"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 2,
            "width": 12,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ELB", "HTTPCode_Backend_3XX", "LoadBalancerName", "${var.prefix}-${var.env}-web-elb" ],
                    [ ".", "HTTPCode_Backend_2XX", ".", "." ],
                    [ ".", "HTTPCode_Backend_4XX", ".", "." ]
                ],
                "region": "eu-west-1",
                "title": "ELB Backend Connection Codes"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 15,
            "width": 12,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "CPUCreditUsage", "AutoScalingGroupName", "${var.prefix}-${var.env}-asg" ],
                    [ ".", "CPUCreditBalance", ".", "." ]
                ],
                "region": "eu-west-1",
                "title": "CPU Credit Usage"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 15,
            "width": 12,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/EC2", "StatusCheckFailed", "AutoScalingGroupName", "${var.prefix}-${var.env}-asg" ]
                ],
                "region": "eu-west-1",
                "title": "Failed Status Checks"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 24,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", "${var.prefix}-${var.env}-asg" ],
                    [ ".", "GroupPendingInstances", ".", "." ],
                    [ ".", "GroupTotalInstances", ".", "." ],
                    [ ".", "GroupInServiceInstances", ".", "." ],
                    [ ".", "GroupTerminatingInstances", ".", "." ]
                ],
                "region": "eu-west-1",
                "title": "ASG Group Metrics"
            }
        }
    ]
}
EOF
}
