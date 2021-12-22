############################################################################
## WEB-ALB
############################################################################
resource "aws_lb" "web-alb" {
  name               = "${local.name_prefix}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-alb.id]
  subnets            = local.pub_subnets

  enable_deletion_protection = true

  access_logs {
    bucket  = var.logging_bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = {
    Environment = var.tags.Environment
    Owner       = var.tags.OwnerTag
    Name        = "${local.name_prefix}-web-alb"
  }

  depends_on = [
    aws_security_group.web
  ]
}

############################################################################
## WEB-ALB - LISTENER - HTTPS
############################################################################

resource "aws_lb_listener" "web-alb-https" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = local.web-alb-listener_https_port # 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.seoul-pingping2_shop.arn
  ssl_policy        = local.ssl_policy
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-alb-http.id
  }
}

############################################################################
# WEB-ALB - LISTENER - Redirect
############################################################################
resource "aws_lb_listener" "web-alb-http-redirect" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = local.web-alb-listener_http_port #80
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
# WEB ALB - Target Group
############################################################################
resource "aws_lb_target_group" "web-alb-http" {
  name     = "${local.name_prefix}-web-alb-http"
  vpc_id   = data.aws_vpc.selected.id
  port     = local.web-alb-listener_http_port
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
# WEB ALB - Target Group attachment
############################################################################
resource "aws_lb_target_group_attachment" "web_instance" {
  target_group_arn = aws_lb_target_group.web-alb-http.arn
  target_id        = module.web.id[0]
  port             = 80
}



############################################################################
# WEB ALB - Security Group
############################################################################
resource "aws_security_group" "web-alb" {
  name        = "${local.name_prefix}-web-alb-sg"
  description = "Internet facing alb Security Group"
  vpc_id      = data.aws_vpc.selected.id
  tags = {
    Name        = "${local.name_prefix}-web-alb-sg"
    Environment = var.tags.Environment
    Owner       = var.tags.OwnerTag
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

############################################################################
# WEB ALB - Security Group - Inbound rule
############################################################################
resource "aws_security_group_rule" "web-alb-ingress-cidrs" {
  type              = "ingress"
  security_group_id = aws_security_group.web-alb.id

  // Dynamic
  for_each    = var.web_alb_ingress_rules
  from_port   = each.value.from
  to_port     = each.value.to
  protocol    = each.value.proto
  cidr_blocks = each.value.cidr
  description = each.value.desc
}