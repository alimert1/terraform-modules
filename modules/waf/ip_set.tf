resource "aws_wafv2_ip_set" "allowed" {
  addresses          = []
  name               = "allowed-IPs"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
}

/*
Bu dosya, WAF IP setlerini tanımlar. IP setleri, belirli IP adreslerini veya IP aralıklarını içeren kümelere izin verir. Örneğin, kötü niyetli IP adreslerini engellemek için kullanılabilir.
*/


resource "aws_wafv2_ip_set" "blocked" {
  addresses          = []
  name               = "blocked-IPs"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
}


resource "aws_wafv2_ip_set" "blocked_ipv6" {
  addresses          = []
  name               = "blocked-IPv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
}