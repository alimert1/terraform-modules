resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = var.load_balancer_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

/*
WAF kurallarının ve web ACL'lerinin belirli kaynaklarla ilişkilendirilmesini sağlar. 
*/