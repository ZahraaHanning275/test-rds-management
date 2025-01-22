resource "aws_secretsmanager_secret" "rds_secrets" {
  for_each    = var.rds_secrets
  name        = each.key
  description = each.value.description
  kms_key_id = aws_kms_key.secrets.arn
}

resource "aws_secretsmanager_secret_version" "aurora_db_secret_version" {
  for_each      = var.rds_secrets
  secret_id     = aws_secretsmanager_secret.rds_secrets[each.key].id
  secret_string = jsonencode({
    username = each.value.username
    password = each.value.password
    engine   = each.value.engine
    host     = each.value.host
    port     = each.value.port
  })
}

# Attaching existing Lambda function to Secrets Manager secret for rotation
#resource "aws_secretsmanager_secret_rotation" "db_credentials_rotation" {
  #for_each          = var.rds_secrets
  #secret_id         = aws_secretsmanager_secret.rds_secrets[each.key].id
  #rotation_lambda_arn = var.rotation_lambda_arn
  #rotation_rules {
    #automatically_after_days = 90
  #}
#}

data "aws_iam_policy_document" "secrets_policy" {
  for_each      = var.rds_secrets
  statement {
    sid    = "statement1"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"] 
    }
    actions = ["secretsmanager:GetSecretValue"]
  
    resources = [aws_secretsmanager_secret.rds_secrets[each.key].arn]
  
    condition {
        test     = "StringNotLike"
        variable = "aws:PrincipalArn"
        values   = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.account_role}"
        ]
     }
 }

  statement {
    effect = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.rds_secrets[each.key].arn] 
    
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::12345555:role/EC2ProvisioningSSMEC2Role",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.account_role}"
        #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.dbadmin_role}"
        #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.postgresql_rotation_lambda}"
        ]
    }
    sid= "Statement2"
  }
}

resource "aws_secretsmanager_secret_policy" "secrets_policy_link" {
  for_each      = var.rds_secrets
  secret_arn = aws_secretsmanager_secret.rds_secrets[each.key].arn
  policy     = data.aws_iam_policy_document.secrets_policy[each.key].json
  #depends_on = [aws_secretsmanager_secret_rotation.db_credentials_rotation,aws_secretsmanager_secret_version.aurora_db_secret_version]
}