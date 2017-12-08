# VPC Module
# Davy Jones
# Cloudreach

#---------- INITIAL VPC CREATION ----------#

resource "aws_vpc" "env" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name  = "${var.prefix}-${var.env}-vpc"
    Owner = "${var.owner}"
  }
}

#---------- SUBNETS ----------#

resource "aws_subnet" "public" {
  count             = "${length(split(",", var.public_subnets))}"
  vpc_id            = "${aws_vpc.env.id}"
  cidr_block        = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"

  tags {
    Name  = "${var.prefix}-${var.env}-public-${count.index}"
    Owner = "${var.owner}"
  }

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = "${length(split(",", var.private_subnets))}"
  vpc_id            = "${aws_vpc.env.id}"
  cidr_block        = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"

  tags {
    Name  = "${var.prefix}-${var.env}-private-${count.index}"
    Owner = "${var.owner}"
  }

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = false
}

#----------- INTERNET GATEWAY ----------#

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.env.id}"

  tags {
    Name  = "${var.prefix}-${var.env}-igw"
    Owner = "${var.owner}"
  }
}

#----------- NAT GATEWAY ----------#

resource "aws_nat_gateway" "private" {
  count         = "${length(split(",", var.private_subnets))}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  depends_on = ["aws_internet_gateway.public"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat" {
  count = "${length(split(",", var.private_subnets))}"
  vpc   = true
}

#----------- ROUTE TABLES ----------#

resource "aws_route_table" "public" {
  count  = "${length(split(",", var.public_subnets))}"
  vpc_id = "${aws_vpc.env.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_internet_gateway.public.*.id, count.index)}"
  }

  tags {
    Name  = "${var.prefix}-${var.env}-public-${count.index}"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", var.public_subnets))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  count  = "${length(split(",", var.private_subnets))}"
  vpc_id = "${aws_vpc.env.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.private.*.id, count.index)}"
  }

  tags {
    Name  = "${var.prefix}-${var.env}-private-${count.index}"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.private_subnets))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}
