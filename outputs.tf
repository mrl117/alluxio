output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.tach.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.tach_public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.tach_private[*].id
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.tach.name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.tach.endpoint
}

output "s3_bucket_tach_name" {
  value = aws_s3_bucket.tach.bucket
}

output "kubeconfig" {
  value = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.tach.endpoint}
    certificate-authority-data: ${aws_eks_cluster.tach.certificate_authority[0].data}
  name: ${aws_eks_cluster.tach.arn}
contexts:
- context:
    cluster: ${aws_eks_cluster.tach.arn}
    user: ${aws_eks_cluster.tach.arn}
  name: ${aws_eks_cluster.tach.arn}
current-context: ${aws_eks_cluster.tach.arn}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.tach.arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.tach.name}"
KUBECONFIG
}