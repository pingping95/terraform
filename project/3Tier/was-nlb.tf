############################################################################
# WAS NLB
############################################################################
resource "aws_lb" "was" {
  name               = "${var.env}-was-nlb"
  internal           = true # Internal Only
  load_balancer_type = "network"
  subnets            = module.main_vpc.private_subnets_ids

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Env = var.env
  }
}


############################################################################
# WAS NLB Listener
############################################################################
resource "aws_lb_listener" "was_https" {
  load_balancer_arn = aws_lb.was.arn

  protocol = "TCP"
  port     = var.was_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was_http.id
  }
}

############################################################################
# WAS NLB Target Group
############################################################################
resource "aws_lb_target_group" "was_http" {
  name     = "${var.env}-was-tg"
  port     = var.was_port
  protocol = "TCP"
  vpc_id   = module.main_vpc.vpc_id
  depends_on = [
    aws_lb.was
  ]

  lifecycle {
    create_before_destroy = true
  }
}


############################################################################
# WAS NLB Attachment
############################################################################

# resource "aws_lb_target_group_attachment" "was_instance" {
#   target_group_arn = aws_lb_target_group.was_http.arn
#   target_id        = module.was.id[0]
#   port             = 8080
# } 