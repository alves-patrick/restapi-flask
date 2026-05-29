resource "aws_eip" "eks_ngw_eip" {
  vpc = true
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-eip"
    }
  )
}

resource "aws_nat_gateway" "eks_ngw" {
  allocation_id = aws_eip.eks_ngw_eip.id
  subnet_id     = aws_subnet.eks_subnet_public_1a.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ngw"
    }
  )
}

resource "aws_route_table" "eks_private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_ngw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-priv-route-table"
    }
  )
}
