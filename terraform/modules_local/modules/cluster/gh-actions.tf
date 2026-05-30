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

  max_session_duration = 43200
}

# Permissão total de administrador para que o Terraform consiga gerenciar toda a infra
resource "aws_iam_role_policy_attachment" "gh_actions_admin_access" {
  role       = aws_iam_role.gh_actions_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
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
