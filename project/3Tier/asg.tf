// Launch Template
resource "aws_launch_template" "web" {
  name                    = "${var.env}-web-launch_template"
  disable_api_termination = var.disable_api_termination
  image_id                = data.aws_ami.web.image_id
  instance_type           = var.web_instance_type
  key_name                = var.key_pair
  vpc_security_group_ids  = [aws_security_group.web.id, aws_security_group.bastion_common.id]
  tags = {
    Name = "${var.env}-web-launch_template"
  }
  default_version = var.web_lt_default_version
  user_data = base64encode(templatefile(
    "./scripts/web/nginx_tomcat.tftpl",
    {
      BACKEND_LB   = aws_lb.was.dns_name
      BACKEND_PORT = var.was_port
      ROOT_DOMAIN  = var.domain
    }
  ))
}

resource "aws_launch_template" "was" {
  name                    = "${var.env}-was-launch_template"
  disable_api_termination = var.disable_api_termination
  image_id                = data.aws_ami.was.image_id
  instance_type           = var.was_instance_type
  key_name                = var.key_pair
  vpc_security_group_ids  = [aws_security_group.was.id, aws_security_group.bastion_common.id]
  tags = {
    Name = "${var.env}-was-launch_template"
  }
  default_version = var.was_lt_default_version
  user_data       = base64encode(file("./scripts/was/was_userdata.sh"))

  iam_instance_profile {
    name = var.was_instance_profile
  }
}


// AutoScaling Group

// WEB
resource "aws_autoscaling_group" "web" {
  name = "${var.env}-web-asg"
  // VPC, Network
  vpc_zone_identifier = module.main_vpc.private_subnets_ids
  // Capacity
  min_size         = var.web_asg_capacity.min
  max_size         = var.web_asg_capacity.max
  desired_capacity = var.web_asg_capacity.desired
  // Launch Template Setting
  launch_template {
    id      = aws_launch_template.web.id
    version = var.web_asg_version
  }
  force_delete = true
  timeouts {
    delete = "15m"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
  tag {
    key                 = "Name"
    value               = "${var.env}-web"
    propagate_at_launch = true
  }
  tag {
    key                 = "ASG"
    value               = true
    propagate_at_launch = true
  }
}

// WAS
resource "aws_autoscaling_group" "was" {
  name = "${var.env}-was-asg"
  // VPC, Network
  vpc_zone_identifier = module.main_vpc.private_subnets_ids
  // Capacity
  min_size         = var.was_asg_capacity.min
  max_size         = var.was_asg_capacity.max
  desired_capacity = var.was_asg_capacity.desired
  // Launch Template Setting
  launch_template {
    id      = aws_launch_template.was.id
    version = var.was_asg_version
  }
  force_delete = true
  timeouts {
    delete = "15m"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
  tag {
    key                 = "Name"
    value               = "${var.env}-was"
    propagate_at_launch = true
  }
  tag {
    key                 = "ASG"
    value               = true
    propagate_at_launch = true
  }
}

// AutoScaling Group Attachment
resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  alb_target_group_arn   = aws_lb_target_group.web_http.id
}
resource "aws_autoscaling_attachment" "was" {
  autoscaling_group_name = aws_autoscaling_group.was.id
  alb_target_group_arn   = aws_lb_target_group.was_http.id
}