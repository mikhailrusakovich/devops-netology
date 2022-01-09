output "aws_account_ID" {
  value = ""
}

output "aws_user_ID" {
  value = ""
}

output "aws_region" {
  value = "us-east-1"
}

output "private_IP_ec2" {
  value = aws_instance.web.private_ip
}

output "subnet_ID" {
  value = aws_subnet.my_subnet.id
}