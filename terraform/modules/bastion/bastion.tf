# Bastion Host Module
# Davy Jones
# Cloudreach

#---------- SECURITY GROUPS ----------#
resource "aws_security_group" "bastion" {
  vpc_id      = "${var.vpc_id}"
  name        = "${var.prefix}-${var.env}-bastion"
  description = "Allow SSH to bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.in_allowed_cidr_blocks)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${split(",", var.in_allowed_cidr_blocks)}"]
  }

  tags {
    Name  = "${var.prefix}-${var.env}-bastion-sg"
    Owner = "${var.owner}"
  }
}

#----------- BASTION HOST ----------#

resource "aws_instance" "bastion" {
  ami                         = "${var.bastion_ami}"
  instance_type               = "${var.bastion_instance_type}"
  key_name                    = "${var.key_name}"
  monitoring                  = true
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  subnet_id                   = "${var.public_subnet_id}"
  associate_public_ip_address = true

  tags {
    Name  = "${var.prefix}-${var.env}-bastion"
    Owner = "${var.owner}"
  }
}
