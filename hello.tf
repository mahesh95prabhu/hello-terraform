provider "aws" {
  region     = "ap-south-1"
  }

data "aws_eks_clusters" "example" {}
data "aws_iam_users" "users" {}


output "hello_world" {	
	value = "Hello, World!"
}
output "eks" {	
	value = data.aws_eks_clusters.example.name
}

output "users" {	
	value = data.aws_iam_users.users.name
}
