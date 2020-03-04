terraform {
  required_version = "~> 0.12, < 0.13"
  backend "s3" {
    bucket         = "matrix-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "matrix-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region  = "us-east-2"
  version = "~> 2.0"
}

data "aws_kms_secrets" "example" {
  count = var.db_password == null ? 1 : 0

  secret {
    name    = "mysql_password"
    payload = "AQICAHh5QZpy3oBX+Xl1UsvKHdiMj2AdQMP1GbYVZ7SOCgXsRQG/vM8rvbBy3USaMmtl+FNmAAAAcDBuBgkqhkiG9w0BBwagYTBfAgEAMFoGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM/rGnnMSy7N//5eN7AgEQgC3RiRoL8SQK1kN8QtfSnVkERRWS0BYz75XGGVKaH9wWOXpdlxxqL6y5BQ0OeQg="

    context = {
      author = "matrix"
    }
  }
}

module "mysql" {
  source      = "../../../../modules/data-stores/mysql/"
  db_name     = "example_mysql"
  db_password = var.db_password == null ? data.aws_kms_secrets.example[0].plaintext["mysql_password"] : var.db_password
}