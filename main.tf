provider "aws" {
    region = "eu-west-2"
}

resource "aws_iam_role" "aws_eks_role_to_assume" {
    name = "aws_eks_role_to_assume"
    assume_role_policy = <<POLICY
{
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Principal" : {
                    "Service" : "eks.amazonaws.com"
                },
                "Action" : "sts:AssumeRole"
            }
        ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "microservice-aws-eks-cluster-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = "${aws_iam_role.aws_eks_role_to_assume.name}"
}

resource "aws_iam_role_policy_attachment" "microservice-aws-eks-cluster-AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role = "${aws_iam_role.aws_eks_role_to_assume.name}"
}


resource "aws_eks_cluster" "microservice-aws-eks-cluster" {
    name = "microservice-aws-eks-cluster"
    role_arn = aws_iam_role.aws_eks_role_to_assume.arn

    vpc_config { // default VPC of the region for now
        subnet_ids = ["subnet-89e691e0", "subnet-535eed29", "subnet-beb071f2"]
    }

    depends_on = [
        aws_iam_role_policy_attachment.microservice-aws-eks-cluster-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.microservice-aws-eks-cluster-AmazonEKSServicePolicy
    ]
}
