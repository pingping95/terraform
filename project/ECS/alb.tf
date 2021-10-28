locals {
  ssl_policy                     = "ELBSecurityPolicy-2016-08"
  nodejs_app_listener_http_port  = 80
  nodejs_app_listener_https_port = 443
}
############################################################################
# Route 53 -> WEB ALB ( A Record )
############################################################################
resource "aws_route53_record" "nodejs_app" {
  zone_id = data.aws_route53_zone.pingping2_shop.zone_id
  name    = var.domain
  type    = "A"
  alias {
    name                   = aws_lb.nodejs_app.dns_name
    zone_id                = aws_lb.nodejs_app.zone_id
    evaluate_target_health = true
  }
}
############################################################################
# WEB ALB - Security Group
############################################################################
resource "aws_security_group" "nodejs_app" {
  name        = "${local.name_prefix}-nodejs-app-alb-sg"
  description = "nodejs_app ALB Security Group"
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
    Name        = "${local.name_prefix}-nodejs_app-alb-sg"
    Environment = var.tags.Environment
  }
}
############################################################################
# WEB ALB
############################################################################
resource "aws_lb" "nodejs_app" {
  name                       = "${local.name_prefix}-nodejs-app-alb"
  internal                   = false # Internet Facing
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.nodejs_app.id]
  subnets                    = module.main_vpc.public_subnets_ids
  enable_deletion_protection = var.nodejs_app_alb_enable_deletion_protection
  tags = {
    Name        = "${local.name_prefix}-nodejs_app-alb"
    Environment = var.tags.Environment
  }
}

############################################################################
# ALB Listener
############################################################################
resource "aws_lb_listener" "nodejs_app" {
  load_balancer_arn = aws_lb.nodejs_app.arn
  port              = local.nodejs_app_listener_https_port # 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.this.arn
  ssl_policy        = local.ssl_policy
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nodejs_app-A.id
  }
}
############################################################################
# ALB Listener - Redirect
############################################################################
resource "aws_lb_listener" "nodejs_app_https_redirect" {
  load_balancer_arn = aws_lb.nodejs_app.arn
  port              = local.nodejs_app_listener_http_port #80
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
# ALB Target Group - A (Blue)
############################################################################
resource "aws_lb_target_group" "nodejs_app-A" {
  name     = "${local.name_prefix}-nodejs-app-tg-A"
  vpc_id   = module.main_vpc.vpc_id
  port     = var.backend_port
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
  target_type = "ip"
  lifecycle {
    create_before_destroy = true
  }
}

############################################################################
# ALB Target Group - B (Green)
############################################################################
resource "aws_lb_target_group" "nodejs_app-B" {
  name     = "${local.name_prefix}-nodejs-app-tg-B"
  vpc_id   = module.main_vpc.vpc_id
  port     = var.backend_port
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
  target_type = "ip"
  lifecycle {
    create_before_destroy = true
  }
}