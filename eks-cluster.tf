#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "random_string" "random" {
  length = 5
  special = false
  upper = false
  number = false
}

resource "aws_iam_role" "setup_step-cluster" {
  name = "terraform-eks-setup_step-cluster-${random_string.random.result}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "setup_step-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.setup_step-cluster.name
}

resource "aws_iam_role_policy_attachment" "setup_step-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.setup_step-cluster.name
}

resource "aws_security_group" "setup_step-cluster" {
  name        = "terraform-eks-setup_step-cluster-${random_string.random.result}"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.setup_step.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "setup_step-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.setup_step-cluster.id
  to_port           = 443
  type              = "ingress"
}


resource "aws_eks_cluster" "setup_step" {
  name     = var.cluster_name
  role_arn = aws_iam_role.setup_step-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.setup_step-cluster.id]
    subnet_ids         = aws_subnet.setup_step[*].id
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.setup_step-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.setup_step-cluster-AmazonEKSServicePolicy
  ]
}
