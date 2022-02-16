# This file will create the s3 bucket and the dynamodb table that is needed for the remote s3 backend,
# as well as the remote backend. https://www.terraform.io/language/settings/backends/s3 is the documentation.

# This will create the S3 bucket that the Terraform state will be stored in.
resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "terraform-state-backend-12343241"
  # versioning is enabled so that every revision of the state file is stored.
  versioning {
    enabled = true
  }
  # Bucket encryption is enabled so that the state file is encrypted.
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  # Setting the acl to private so that only the owner of the bucket can access the state file.    
  acl = "private"
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
  # this is only for the demo in order for us
  # to be able to destroy a non-empty bucket
  force_destroy = true
}

# Guarantees that the bucket is not publicly accessible for security reasons.
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform-state-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# This will create the DynamoDB table that will lock the state file when in use.
# To prevent team members from writing to the state file at the same time.
resource "aws_dynamodb_table" "terraform-lock" {
  name           = "terraform_state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}


/* terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-12343241"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
    profile        = "admin-ray-train"
  }
} */