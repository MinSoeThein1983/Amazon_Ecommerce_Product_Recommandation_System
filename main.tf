provider "aws" {
  region = "ap-southeast-1"  # Replace with your desired AWS region
}

variable "bucket_name" {
  default = "MinSoe-amazon-product-dataset"  # Replace with a unique bucket name
}

variable "file_path" {
  default = "E:/Data Engineer/Data Engineer Project Portfolio/Amazon Ecommerce Product Recommandation System/DataSet/"  # Directory path
}

# Create the S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "DataEngineerProjectBucket"
    Environment = "Development"
  }
}

# Define the ACL for the S3 bucket
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"  # Change to your desired ACL setting
}

# Upload each CSV file to the S3 bucket using fileset
resource "aws_s3_object" "file_upload" {
  for_each = fileset(var.file_path, "*.csv")

  bucket = aws_s3_bucket.bucket.id
  key    = each.value  # Use the filename as the key
  source = "${var.file_path}${each.value}"  # Specify the full path to the file

  acl = "public-read"  # Optional: Make the file publicly accessible
}
