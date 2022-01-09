# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
  resource "aws_vpc" "my_vpc" {
    cidr_block = "172.16.0.0/16"

    tags = {
      Name = "tf-example"
    }
  }

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  monitoring = true
  cpu_core_count = 1
  cpu_threads_per_core = 2

  root_block_device {
    delete_on_termination = true
    iops                  = 150
    volume_size           = 10
    volume_type           = "gp3"
  }
  tags = {
    Name = "HelloWorld"
  }
}