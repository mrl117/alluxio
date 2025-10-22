# S3
data "aws_caller_identity" "current" {}

# EKS
data "aws_eks_cluster_auth" "tach" {
  name = aws_eks_cluster.tach.name
}

data "tls_certificate" "tach_cluster" {
  url = aws_eks_cluster.tach.identity[0].oidc[0].issuer
}


#data "aws_security_group" "eks_worker_sg" {
#  id = "sg-007d0ce072808a4b0"
#}