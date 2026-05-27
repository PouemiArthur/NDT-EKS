data "aws_iam_policy_document" "externaldnsassumerolepolicy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    Effect = "allow"
    condition {
      test = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values = ["system:serviceaccount:kube-system:external-dns"]
      }
    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type = "federated"
      }
   }
}

resource "aws_iam_policy" "externaldns" {
  name = "externaldnsrt53policy"
 
  policy = jsonencode({
    version = "2012-10-17"
    statement = [
      {
        Effect = "allow"
        Action = ["route53:ChangeResourceRecordSets"]
        Resource = ["arn:aws:route53:::hostedzone/${data.aws_route53.primary.zone_id}"]
       },
        {
          Effect = "Allow"
          Action = ["route53:ListHostedZones", "route53:ListResourceRecordSets"]
          resource = ["*"]
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "attachexternaldns" {
  name = "externaldns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart = "external-dns"
  namespace = "kube-system"
  
  set {
    name = "provider"
    value = "aws"
    }
  set {
    name = "txtOwnerId"
    value = data.aws_route_zone.primary.zone_id
    }
  set {
    name = "ServiceAccount.create"
    value = "true"
    }
  set {
    name = "ServiceAccount.name"
    value = "external-dns"
    }
  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns.arn
    }
}







