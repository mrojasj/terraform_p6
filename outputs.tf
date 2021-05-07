output "vpc_id" {
  value = aws_vpc.main.id
  description = "Main VPC ID"
}

output "public_ip" {
  value = aws_instance.web.public_ip
  sensitive = true
}

output "subnet_ids" {
  value = aws_subnet.this[*].id
}