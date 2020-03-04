terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
}

module "hello_world_app" {
  source = "../../../../modules/services/hello-world-app/"

  db_remote_state_bucket = "matrix-terraform-state"
  db_remote_state_key    = "global/s3/terraform.tfstate"
  instance_type          = "t2.micro"

  environment        = "stage"
  max_size           = 2
  min_size           = 2
  enable_autoscaling = false
}

