terraform {
  required_providers {
      aws= {
          source = "aws"
      }
  }
}
provider "aws" {
  profile = "default"
  region = "us-east-2"
  access_key = "******"
  secret_key = "******"
}
resource "aws_instance" "example" {
  ami = "ami-0a0ad6b70e61be944"
  instance_type = "t2.micro"
}