resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_a" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.1.0/24"
 availability_zone = "ap-south-1a"
 map_public_ip_on_launch = true
}

resource "aws_subnet" "public_b" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.2.0/24"
 availability_zone = "ap-south-1b"
 map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
}
