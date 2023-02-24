provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA5OKKGS3Z5HQ3U22P"
  secret_key = "T8L47AMg5xV18fWuWO15R0kBFk8X85xuEa0hMnwQ"
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
