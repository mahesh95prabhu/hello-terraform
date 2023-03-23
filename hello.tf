terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}



resource "aws_spot_instance_request" "cheap_worker" {
  ami           = "ami-0d81306eddc614a45"
  spot_price    = "0.01"
  instance_type = "t3a.nano"
  availability_zone = "ap-south-1a"
  spot_type = "one-time"
  block_duration_minutes= 60
  tags = {
    Name = "CheapWorker"
  }
}

data "aws_instances" "test" {
  instance_tags = {
    Role = "CheapWorker"
  }

  instance_state_names = ["running"]
}output ec2 {
  value       = data.aws_instances.id
  sensitive   = true
  description = "description"
  depends_on  = []
}
