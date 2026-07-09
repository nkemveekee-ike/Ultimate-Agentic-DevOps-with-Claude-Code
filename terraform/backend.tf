# Remote State Backend (S3 + DynamoDB)
#
# SETUP INSTRUCTIONS:
# 1. On first run, leave this block commented out.
# 2. Run `terraform init && terraform apply` to provision S3 + CloudFront.
# 3. Create a separate S3 bucket and DynamoDB table for Terraform state (outside this config).
# 4. Uncomment the backend block below, fill in your values, then run:
#      terraform init -migrate-state
#    Terraform will prompt you to copy existing local state to the remote backend.
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"   # S3 bucket for state storage
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "terraform-state-lock"          # DynamoDB table for state locking
#     encrypt        = true
#   }
# }
