##========================================================================================
##                                                                                      ##
##                                       Providers                                      ##
##                                                                                      ##
##========================================================================================

terraform {
  required_version = "~> 1.0.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.58"
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  # This is the AWS profile name as set in the shared credentials file.
  profile = "aws_profile_name"

  # (Optional) List of allowed AWS account IDs to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment)
  # allowed_account_ids = ["12345"]

  default_tags {
    tags = {
      Created_by  = "Terraform"
      Environment = local.environment
    }
  }
}

##========================================================================================
##                                                                                      ##
##                                     Locals                                           ##
##                                                                                      ##
##========================================================================================

locals {
  environment  = "prd"
  project_name = "example"
}

##========================================================================================
##                                                                                      ##
##                                     State backend                                    ##
##                                                                                      ##
##========================================================================================

module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"

  version                            = "0.37.0"
  namespace                          = local.environment
  stage                              = local.project_name
  name                               = "terraform"
  attributes                         = ["state"]
  billing_mode                       = "PAY_PER_REQUEST"
  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}
# To initialize and push state to s3
# follow instructions -> https://registry.terraform.io/modules/cloudposse/tfstate-backend/aws/latest
