variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "example_database_stage"
}

variable "db_password" {
  description = "The password of the database, if you not use the KMS (store as plaintext!)"
  type        = string
  default     = "aksdhaisldhkh"
}