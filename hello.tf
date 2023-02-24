provider "aws" {
  region     = "ap-south-1"
  AWS_ACCESS_KEY_ID   = "${{ secrets.AWS_ACCESS_KEY_ID }}"
  AWS_SECRET_ACCESS_KEY  = "${{ secrets.AWS_SECRET_ACCESS_KEY }}"
  }

data "aws_eks_clusters" "example" {}
data "aws_iam_users" "users" {}


output "hello_world" {	
	value = "Hello, World!"
}
output "eks" {	
	value = data.aws_eks_clusters.example.names
}

output "users" {	
	value = data.aws_iam_users.users.names
}
