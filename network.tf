resource "aws_vpc" "tach" {
  cidr_block           = var.vpc_tach_cidr_block
  enable_dns_support   = var.vpc_tach_edns_support
  enable_dns_hostnames = var.vpc_tach_edns_hostnames

  tags = {
    name = var.vpc_tach_name
  }
}

resource "aws_internet_gateway" "tach" {
  vpc_id = aws_vpc.tach.id

  tags = {
    name = var.igw_tach_name
  }
}

## Subnet
### Public
resource "aws_subnet" "tach_public" {
  vpc_id                  = aws_vpc.tach.id
  count                   = length(var.subnet_tach_public_cidrs)
  cidr_block              = var.subnet_tach_public_cidrs[count.index]
  availability_zone       = var.subnet_tach_availability_zones[count.index]
  map_public_ip_on_launch = var.subnet_tach_public_map

  tags = {
    name = var.subnet_tach_public_name
  }
}

### Private (for EKS nodes)
resource "aws_subnet" "tach_private" {
  vpc_id                  = aws_vpc.tach.id
  count                   = length(var.subnet_tach_private_cidrs)
  cidr_block              = var.subnet_tach_private_cidrs[count.index]
  availability_zone       = var.subnet_tach_availability_zones[count.index]
  map_public_ip_on_launch = var.subnet_tach_private_map

  tags = {
    name = var.subnet_tach_private_name
  }
}

# NAT Gateway
resource "aws_eip" "nat" {
  tags = {
    Name = "eks-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.tach_public[0].id

  tags = {
    Name = "eks-nat"
  }
  
  depends_on = [aws_internet_gateway.tach]
}

# Route tables
## Public
resource "aws_route_table" "tach_public" {
  vpc_id = aws_vpc.tach.id

  route {
    cidr_block = var.routetable_tach_public_igw_cidr_block
    gateway_id = aws_internet_gateway.tach.id
  }

  tags = { 
    name = var.routetable_tach_public_name 
  }
}

resource "aws_route_table_association" "tach_public" {
  count          = length(aws_subnet.tach_public)
  subnet_id      = aws_subnet.tach_public[count.index].id
  route_table_id = aws_route_table.tach_public.id
}

## Private
resource "aws_route_table" "tach_private" {
  vpc_id = aws_vpc.tach.id

  route {
    cidr_block     = var.routetable_tach_private_nat_cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { 
    name = var.routetable_tach_private_name 
  }
}

resource "aws_route_table_association" "tach_private" {
  count          = length(aws_subnet.tach_private)
  subnet_id      = aws_subnet.tach_private[count.index].id
  route_table_id = aws_route_table.tach_private.id
}

# Security Group for EKS
resource "aws_security_group" "eks" {
  name        = var.sg_tach_eks_name
  description = var.sg_tach_eks_description
  vpc_id      = aws_vpc.tach.id
}