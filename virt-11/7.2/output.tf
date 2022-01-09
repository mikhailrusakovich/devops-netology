output "private_IP_ec2" {
  value = aws_instance.web.private_ip
}

output "subnet_ID" {
  value = aws_subnet.my_subnet.id
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

data "aws_region" "current" {}