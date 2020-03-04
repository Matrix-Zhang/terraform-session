output "address" {
  description = "Connect to the database at this endpoin"
  value       = aws_db_instance.example.address
}

output "port" {
  description = "The port the database is listening on"
  value       = aws_db_instance.example.port
}