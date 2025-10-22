# tach
resource "aws_s3_bucket" "tach" {
  bucket        = var.bucket_name
  force_destroy = var.s3_bucket_force_destroy

  tags = var.tags
}