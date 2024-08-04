resource "aws_iam_role" "eks_role" {
    name = "eksrole"
     assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = aws_iam_role.eks_role.id
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
    role = aws_iam_role.eks_role.id
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"

}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "public" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
}

resource "aws_eks_cluster" "eks_cluster" {
    name = "my_cluster"
    role_arn = aws_iam_role.eks_role.arn
    vpc_config {
      subnet_ids = data.aws_subnets.public.ids

    }

}
resource "aws_iam_role" "eks-node-group" {
    name = "eks-node-group"
     assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "esk-node_AmazonEKSWorkerNodePolicy" {
    role = aws_iam_role.eks-node-group.id
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}
resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
    role = aws_iam_role.eks-node-group.id
    policy_arn ="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}
resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
    role = aws_iam_role.eks-node-group.id
    policy_arn ="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}




resource "aws_eks_node_group" "cluster_group" {
    cluster_name = aws_eks_cluster.eks_cluster.name
    node_group_name = "eks_group"
    node_role_arn = aws_iam_role.eks-node-group.arn
    subnet_ids = data.aws_subnets.public.ids
    scaling_config {
      desired_size = 1
      max_size = 2
      min_size = 1
    }
    instance_types = [ "t2.medium" ]

}


output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
    value = aws_eks_cluster.eks_cluster.name


}
