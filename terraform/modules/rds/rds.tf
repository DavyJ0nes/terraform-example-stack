# RDS Module
# Davy Jones
# Cloudreach

#---------- CREATE DB SUBNET GROUP ----------#

resource "aws_db_subnet_group" "rds" {
  name       = "${var.prefix}-${var.env}-rds"
  subnet_ids = ["${split(",", var.subnets)}"]

  tags {
    Name  = "${var.prefix}-${var.env}-rds"
    Owner = "${var.owner}"
  }
}

#------- SET UP RDS SECURITY GROUP ----------#
resource "aws_security_group" "rds" {
  name        = "${var.prefix}-${var.env}-rds-sg"
  vpc_id      = "${var.vpc_id}"
  description = "RDS Security Group"

  tags {
    Name  = "${var.prefix}-${var.env}-rds-sg"
    Owner = "${var.owner}"
  }

  ingress {
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = ["${var.security_group}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#---------- CREATE DB INSTANCE ----------#

resource "aws_db_instance" "rds" {
  allocated_storage         = "${var.db_size}"
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.6.35"
  instance_class            = "${var.instance_class}"
  identifier                = "${var.prefix}-${var.env}"
  name                      = "${var.db_prefix}${title(var.env)}"
  username                  = "${var.username}"
  password                  = "${var.password}"
  port                      = "${var.port}"
  multi_az                  = "${var.multi_az}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  final_snapshot_identifier = "${var.final_snapshot_name}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  availability_zone         = "${var.az}"
  db_subnet_group_name      = "${aws_db_subnet_group.rds.name}"
  parameter_group_name      = "default.mysql5.6"

  tags {
    Name  = "${var.prefix}-${var.env}-rds"
    Owner = "${var.owner}"
  }
}

#---------- SUBSCRIBE TO DB EVENTS ----------#

resource "aws_db_event_subscription" "rds" {
  name      = "${var.prefix}-${var.env}-rds-event-sub"
  sns_topic = "${var.sns_topic}"

  source_type = "db-instance"
  source_ids  = ["${aws_db_instance.rds.id}"]

  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]

  tags {
    Name  = "${var.prefix}-${var.env}-rds"
    Owner = "${var.owner}"
  }
}
