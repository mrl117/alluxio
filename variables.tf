variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tach: A mapping of tags"
  type        = map(any)
}

variable "s3_bucket_force_destroy" {
  description = "Tach: A boolean that indicates all objects should be deleted from S3 buckets so that the buckets can be destroyed without error. These objects are not recoverable"
  type        = bool
}

# S3-Bucket
## Tach
variable "bucket_name" {
  description = "Tach: create a bucket with the specified name to connect minIO"
  type        = string
}

# EKS
variable "cluster_tach_name" {
  description = "Tach: EKS cluster name"
  type        = string
}

variable "node_group_tach_name" {
  description = "Tach: EKS node group name"
  type        = string
}

variable "node_group_tach_config_desired" {
  description = "Tach: EKS node group - config desired size"
  type        = number
}

variable "node_group_tach_config_max" {
  description = "Tach: EKS node group - config max size"
  type        = number
}

variable "node_group_tach_config_min" {
  description = "Tach: EKS node group - config min size"
  type        = number
}

variable "node_group_tach_instance_types" {
  description = "Tach: EKS node group - instance types"
  type        = list(string)
}

# Networking
## VPC
variable "vpc_tach_name" {
  description = "Tach: VPC name"
  type        = string
}

variable "vpc_tach_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_tach_edns_support" {
  description = "Tach: VPC - enable DNS support"
  type        = bool
}

variable "vpc_tach_edns_hostnames" {
  description = "Tach: VPC - enable DNS hostnames"
  type        = bool
}

## Internet Gateway
variable "igw_tach_name" {
  description = "Tach: Internet Gateway name"
  type        = string
}

## Subnet
variable "subnet_tach_availability_zones" {
  description = "Tach: availability zones for subnets"
  type        = list(string)
}

### Public
variable "subnet_tach_public_name" {
  description = "Tach: Public subnet name"
  type        = string
}

variable "subnet_tach_public_cidrs" {
  description = "Tach: list of CIDR blocks for public subnet"
  type        = list(string)
}

variable "subnet_tach_public_map" {
  description = "Tach: Map public IP on launch for public subnet"
  type        = bool
}

### Private
variable "subnet_tach_private_name" {
  description = "Tach: Private subnet name"
  type        = string
}

variable "subnet_tach_private_cidrs" {
  description = "Tach: list of CIDR blocks for private subnet"
  type        = list(string)
}

variable "subnet_tach_private_map" {
  description = "Tach: Map public IP on launch for private subnet"
  type        = bool
}

# Route tables
## Public
variable "routetable_tach_public_name" {
  description = "Tach: public route table name"
  type        = string
}

variable "routetable_tach_public_igw_cidr_block" {
  description = "Tach: internet access route for public route table"
  type        = string
}

## Private
variable "routetable_tach_private_name" {
  description = "Tach: public route table name"
  type        = string
}

variable "routetable_tach_private_nat_cidr_block" {
  description = "Tach: nat route for private route table"
  type        = string
}

# Security Groups
variable "sg_tach_eks_name" {
  description = "Tach: security group name for EKS"
  type        = string
}

variable "sg_tach_eks_description" {
  description = "Tach: security group description for EKS"
  type        = string
}

variable "sg_tach_rds_name" {
  description = "Tach: security group name for RDS"
  type        = string
}

variable "sg_tach_rds_description" {
  description = "Tach: security group description for RDS"
  type        = string
}

variable "sgr_tach_ingress_type" {
  description = "Tach: type for ingress security group rule"
  type        = string
}

variable "sgr_tach_ingress_from_port" {
  description = "Tach: origin port for ingress security group rule"
  type        = number
}

variable "sgr_tach_ingress_to_port" {
  description = "Tach: destination port of ingress security group rule"
  type        = number
}

variable "sgr_tach_ingress_protocol" {
  description = "Tach: protocol for ingress security group rule"
  type        = string
}

variable "sg_tach_db_rds_name" {
  description = "Tach: db security group name"
  type        = string
}

# RDS Instance
#variable "rds_instance_identifier" {
#  description = "RDS instance identifier"
#  type        = string
#}
#
#variable "rds_db_name" {
#  description = "RDS DB name"
#  type        = string
#}
#
#variable "rds_username" {
#  description = "Tach: RDS master username"
#  type        = string
#}
#
#variable "rds_password" {
#  description = "Tach: RDS master password"
#  type        = string
#  sensitive   = true
#}
#
#variable "rds_instance_class" {
#  description = "Tach: RDS instance type"
#  type        = string
#}
#
#variable "rds_allocated_storage" {
#  description = "Tach: RDS storage size"
#  type        = number
#}

# IAM
## EKS
variable "iamrole_tach_eks_name" {
  description = "Tach: IAM role name for EKS"
  type        = string
}

## EKS Nodes
variable "iamrole_tach_eks_node_name" {
  description = "Tach: IAM role name for EKS node"
  type        = string
}