locals {
  ssl_policy              = "ELBSecurityPolicy-2016-08"
  web_listener_http_port  = 80
  web_listener_https_port = 443
}
############################################################################
# Route 53 -> WEB ALB ( A Record )
############################################################################
resource "aws_route53_record" "web_alb" {
  zone_id = data.aws_route53_zone.pingping2_shop.zone_id
  name    = var.domain
  type    = "A"
  alias {
    name                   = aws_lb.web.dns_name
    zone_id                = aws_lb.web.zone_id
    evaluate_target_health = true
  }
}
############################################################################
# WEB ALB - Security Group
############################################################################
resource "aws_security_group" "web_alb" {
  name        = "${var.env}-web-alb-sg"
  description = "Web ALB Security Group"
  vpc_id      = module.main_vpc.vpc_id
  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-web-alb-sg"
  }
}
############################################################################
# WEB ALB
############################################################################
resource "aws_lb" "web" {
  name                       = "${var.env}-${var.web_lb_name}"
  internal                   = false # Internet Facing
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.web_alb.id]
  subnets                    = module.main_vpc.public_subnets_ids
  enable_deletion_protection = var.web_alb_enable_deletion_protection
  tags = {
    Env = var.env
  }
}
############################################################################
# WEB ALB Listener
############################################################################
resource "aws_lb_listener" "web_https" {
  load_balancer_arn = aws_lb.web.arn
  port              = local.web_listener_https_port
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.web.arn
  ssl_policy        = local.ssl_policy
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_http.id
  }
}
############################################################################
# WEB ALB Listener - Redirect
############################################################################
resource "aws_lb_listener" "web_https_redirect" {
  load_balancer_arn = aws_lb.web.arn
  port              = local.web_listener_http_port #80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
############################################################################
# WEB ALB Target Group
############################################################################
resource "aws_lb_target_group" "web_http" {
  name     = "${var.env}-web-tg"
  vpc_id   = module.main_vpc.vpc_id
  port     = var.web_port
  protocol = "HTTP"
  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = 200
  }
  target_type = "instance"
  lifecycle {
    create_before_destroy = true
  }
}
############################################################################
# WEB ALB Attachment here
############################################################################
# resource "aws_lb_target_group_attachment" "web_instance" {
#   target_group_arn = aws_lb_target_group.web_http.arn
#   target_id        = module.web.id[0]
#   port             = 80
# }