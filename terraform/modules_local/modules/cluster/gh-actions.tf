data "tls_certificate" "gh_actions_tls_certificate" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "gh_actions_oidc" {
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = data.tls_certificate.gh_actions_tls_certificate.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.gh_actions_tls_certificate.url
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-gh-actions-oidc"
    }
  )
}

resource "aws_iam_role" "gh_actions_oidc_role" {
  name = "${var.project_name}-gh-actions-oidc-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "${aws_iam_openid_connect_provider.gh_actions_oidc.arn}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:alves-patrick/restapi-flask:*"
                }
            }
        }
    ]
}
EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-gh-actions-oidc-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "gh_actions_oidc_ecr_full" {
  role       = aws_iam_role.gh_actions_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_policy" "gh_actions_eks_ro" {
  name        = "${var.project_name}-eks-ro"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "gh_actions_oidc_eks_ro" {
  role       = aws_iam_role.gh_actions_oidc_role.name
  policy_arn = aws_iam_policy.gh_actions_eks_ro.arn
}

# Permissões para o GitHub Actions ler/escrever o estado do Terraform no S3 e DynamoDB
resource "aws_iam_policy" "gh_actions_terraform_state" {
  name        = "${var.project_name}-gh-actions-tf-state"
  description = "Permite que o GitHub Actions gerencie o estado do Terraform no S3 e DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3Backend"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketPublicAccessBlock"
        ]
        Resource = "arn:aws:s3:::restapi-flask-terraform-state-142517507342"
      },
      {
        Sid    = "AllowS3StateFile"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::restapi-flask-terraform-state-142517507342/*"
      },
      {
        Sid    = "AllowDynamoLock"
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:142517507342:table/restapi-flask-terraform-lock"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "gh_actions_oidc_tf_state" {
  role       = aws_iam_role.gh_actions_oidc_role.name
  policy_arn = aws_iam_policy.gh_actions_terraform_state.arn
}

# Permissão para o GitHub Actions gerenciar o Cluster (Kubernetes Admin)
resource "aws_eks_access_entry" "gh_actions" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = aws_iam_role.gh_actions_oidc_role.arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "gh_actions_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_iam_role.gh_actions_oidc_role.arn

  access_scope {
    type = "cluster"
  }
}