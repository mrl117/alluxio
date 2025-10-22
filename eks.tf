resource "aws_eks_cluster" "tach" {
  name     = var.cluster_tach_name
  role_arn = aws_iam_role.eks_tach.arn

  vpc_config {
    subnet_ids = concat(aws_subnet.tach_public[*].id, aws_subnet.tach_private[*].id)
    endpoint_public_access  = true
    endpoint_private_access = false
    security_group_ids      = [aws_security_group.eks.id]
  }

#  kubernetes_network_config {
#    service_ipv4_cidr = "172.20.0.0/16"
#  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_tach,
    aws_iam_role_policy_attachment.eks_tach_vpc
  ]

  tags = var.tags
}

# Node Group
resource "aws_eks_node_group" "tach" {
  node_group_name = var.node_group_tach_name
  cluster_name    = aws_eks_cluster.tach.name
  node_role_arn   = aws_iam_role.eks_node_tach.arn
  subnet_ids      = aws_subnet.tach_private[*].id

  scaling_config {
    desired_size = var.node_group_tach_config_desired
    max_size     = var.node_group_tach_config_max
    min_size     = var.node_group_tach_config_min
  }

  instance_types = var.node_group_tach_instance_types

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_tach,
    aws_iam_role_policy_attachment.eks_node_tach_cni,
    aws_iam_role_policy_attachment.eks_node_tach_ec2_registry
  ]

  tags = var.tags
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tach_cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.tach.identity[0].oidc[0].issuer
}