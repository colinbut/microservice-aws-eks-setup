resource "aws_iam_role" "microservice-aws-eks-node-group-role" {
    name = "microservice-aws-eks-node-group-role"
    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}


resource "aws_iam_role_policy_attachment" "microservice-aws-eks-AmazonEKSWokerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.microservice-aws-eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "microservice-aws-eks-AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.microservice-aws-eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "microservice-aws-eks-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.microservice-aws-eks-node-group-role.name
}

resource "aws_eks_node_group" "microservice-aws-eks-node-group" {
    cluster_name = var.cluster
    node_group_name = "microservice-aws-eks-node-group"
    node_role_arn = aws_iam_role.microservice-aws-eks-node-group-role.arn

    scaling_config {
        desired_size = 1
        max_size = 3
        min_size = 1
    }

    subnet_ids = ["subnet-89e691e0", "subnet-535eed29", "subnet-beb071f2"]

    depends_on = [
        aws_iam_role_policy_attachment.microservice-aws-eks-AmazonEKSWokerNodePolicy,
        aws_iam_role_policy_attachment.microservice-aws-eks-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.microservice-aws-eks-AmazonEC2ContainerRegistryReadOnly
    ]
}



