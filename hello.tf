provider "aws" {
  region     = "ap-south-1"
  }

data "aws_eks_clusters" "example" {}

output "hello_world" {	
	value = "Hello, World!"
}
output "eks" {	
	value = data.aws_eks_clusters.example.name
}
