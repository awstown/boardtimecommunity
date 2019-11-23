provider "aws" {
    region = "us-west-2"
}

resource "aws_vpc" "main_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "boardtime-aws-vpc"
    }
}

resource "aws_eip" "nat" {
    vpc = true
}

resource "aws_eip" "web-1" {
    instance = "${aws_instance.web-1.id}"
    vpc = true
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.ig-main.id}"
    }

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.main_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat.id}"

    }

    tags = {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main_vpc.id}"

    cidr_block = "${var.public_subnet_cidr}"

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.main_vpc.id}"

    cidr_block = "${var.private_subnet_cidr}"

    tags = {
        Name = "Private Subnet"
    }
}

resource "aws_internet_gateway" "ig-main" {
    vpc_id = "${aws_vpc.main_vpc.id}"
}
resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public.id}"

    tags = {
        Name = "NAT"
    }
}
