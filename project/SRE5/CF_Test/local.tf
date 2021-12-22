locals {
  name_prefix                 = "${var.tags["Service"]}-${var.tags["Environment"]}-${var.tags["RegionAlias"]}"
  pub_subnets                 = values(var.network_config.public_subnet)
  pri_subnets                 = values(var.network_config.private_subnet)
  ssl_policy                  = "ELBSecurityPolicy-2016-08"
  web-alb-listener_http_port  = 80
  web-alb-listener_https_port = 443
}