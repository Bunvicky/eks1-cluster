resource "aws_iam_role" "bunmi" {
  name               = "eks-cluster-bunmi"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

resource "aws_iam_policy" "eks_cluster" {
  name   = "eks-cluster-bunmi"
  policy = data.aws_iam_policy_document.eks_cluster.json
}

resource "aws_iam_role_policy_attachment" "bunmi-AmazonEKSClusterPolicy" {
  #policy_arn = aws_iam_policy.eks_cluster.arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.bunmi.name
}

resource "aws_eks_cluster" "bunmi" {
  name     = "bunmi"
  role_arn = aws_iam_role.bunmi.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public[0].id,aws_subnet.public[1].id,
      aws_subnet.private[0].id, aws_subnet.private[0].id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.bunmi-AmazonEKSClusterPolicy]
}

/*
module "vpc" {
  source = "../vpc"
}*/
