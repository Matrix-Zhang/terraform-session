terraform {
  required_version = "~> 0.12, < 0.13"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform"
  engine              = "mysql"
  instance_class      = "db.t2.micro"
  allocated_storage   = 10
  username            = "admin"
  name                = var.db_name
  password            = var.db_password
  skip_final_snapshot = true
}
