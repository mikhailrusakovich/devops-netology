output "aws_account_ID" {
  value = "AKIARUHNNKQQLNB2B4EN"
}

output "aws_user_ID" {
  value = "xpUFMXuUNew+VL9pLI5ygE769G7r+KpD9PZvT9ld"
}

output "aws_region" {
  value = "us-east-1"
}

output "private_IP_ec2" {
  value = aws_instance.foo.private_ip
}

output "subnet_ID" {
  value = aws_subnet.my_subnet.id
}