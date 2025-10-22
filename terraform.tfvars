aws_region  = "us-east-1"

tags = {
  Environment = "dev"
  Version     = "1.0.0"
}

s3_bucket_force_destroy = false

# S3-Bucket
bucket_name = "tach-dev-s3-minio-001"

# EKS
cluster_tach_name              = "tach-dev-eks-cluster-001"
node_group_tach_name           = "tach-dev-eks-ngroup-001"
node_group_tach_config_desired = 3
node_group_tach_config_max     = 5
node_group_tach_config_min     = 3
node_group_tach_instance_types = ["m5.4xlarge"]

# Network
## VPC
vpc_tach_name           = "tach-dev-vpc-cluster-001"
vpc_tach_cidr_block     = "10.0.0.0/16"
vpc_tach_edns_support   = true
vpc_tach_edns_hostnames = true

## Internet Gateway
igw_tach_name           = "tach-dev-igw-cluster-001"

## Subnet
subnet_tach_availability_zones = ["us-east-1a", "us-east-1b"]
### Public
subnet_tach_public_name  = "tach-dev-snet-public-001"
subnet_tach_public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
subnet_tach_public_map   = true

### Private
subnet_tach_private_name = "tach-dev-snet-private-001"
subnet_tach_private_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
subnet_tach_private_map   = false

## RouteTable
### Public
routetable_tach_public_name           = "tach-dev-rt-public-001"
routetable_tach_public_igw_cidr_block = "0.0.0.0/0"

## Private
routetable_tach_private_name           = "tach-dev-rt-private-001"
routetable_tach_private_nat_cidr_block = "0.0.0.0/0"

## Security Groups
sg_tach_eks_name        = "tach-dev-sg-eks-001"
sg_tach_eks_description = "Tach: security group for EKS cluster"

sg_tach_rds_name        = "tach-dev-sg-rds-001"
sg_tach_rds_description = "Tach: security group for RDS"

sgr_tach_ingress_type      = "ingress"
sgr_tach_ingress_from_port = 5432
sgr_tach_ingress_to_port   = 5432
sgr_tach_ingress_protocol  = "tcp"

sg_tach_db_rds_name        = "tach-dev-dbsg-eks-001"


## RDS Instance
#rds_instance_identifier = "eks-rds-postgresql"
#rds_db_name             = "app_db"
#rds_username            = "userTest"
#rds_password            = "Test1313C4pW$rlG3n3s."
#rds_instance_class      = "db.t3.micro"
#rds_allocated_storage   = 20

# IAM
## EKS
iamrole_tach_eks_name = "tach-dev-iamrole-eks-001"

## EKS Nodes
iamrole_tach_eks_node_name = "tach-dev-iamrole-eksnode-001"