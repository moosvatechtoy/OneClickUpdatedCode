#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "setup_step" {
  cidr_block = var.vpc_cidr_block

  tags = map(
    "Name", "${var.cluster_name}",
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_subnet" "setup_step" {
  count  = length(var.vpc_subnet)

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = element(var.vpc_subnet, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.setup_step.id

  tags = map(
    "Name", "${var.cluster_name}",
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_internet_gateway" "setup_step" {
  vpc_id = aws_vpc.setup_step.id

  tags = {
    Name = "${var.cluster_name}"
  }
}

resource "aws_route_table" "setup_step" {
  vpc_id = aws_vpc.setup_step.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.setup_step.id
  }
}

resource "aws_route_table_association" "setup_step" {
  count = length(var.vpc_subnet)

  subnet_id      = aws_subnet.setup_step.*.id[count.index]
  route_table_id = aws_route_table.setup_step.id
}
