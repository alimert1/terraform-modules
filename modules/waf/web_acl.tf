resource "aws_wafv2_web_acl" "main" {
  description = "limon-prod-web-acl"
  name        = "limon-prod-web-acl"
  scope       = "REGIONAL"

  default_action {
    allow {
    }
  }

  rule {
    name     = "blocked-IPs"
    priority = 2

    action {
      block {
      }
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "blocked-IPs"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "blocked-IPv6"
    priority = 3

    action {
      block {
      }
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked_ipv6.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "blocked-IPv6"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "rate-limit"
    priority = 4

    action {
      count {
      }
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "FORWARDED_IP"
        limit              = 1000

        forwarded_ip_config {
          fallback_behavior = "MATCH"
          header_name       = "CF-Connecting-IP"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 11

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "AdminProtection_URIPATH"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 6

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"

        rule_action_override {
          name = "AWSManagedIPDDoSList"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "AWSManagedIPReputationList"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "AWSManagedReconnaissanceList"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 9

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "COMMON"
          }
        }

        rule_action_override {
          name = "CategoryAdvertising"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryArchiver"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryContentFetcher"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryEmailClient"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryHttpLibrary"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryLinkChecker"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryMiscellaneous"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryMonitoring"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryScrapingFramework"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySearchEngine"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySecurity"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySeo"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySocialMedia"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalAutomatedBrowser"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalKnownBotDataCenter"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalNonBrowserUserAgent"

          action_to_use {
            count {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "allowed-IPs"
    priority = 0

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.allowed.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allowed-IPs"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "country-restriction"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.country.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "country-restriction"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "limon-prod-web-acl"
    sampled_requests_enabled   = true
  }
}