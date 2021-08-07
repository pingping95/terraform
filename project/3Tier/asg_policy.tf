# #######################################################################################
// 1. WEB
#######################################################################################
// Scale up
//  1) ASG Policy
resource "aws_autoscaling_policy" "web_scaleup" {
  name               = "${var.env}-web-cpu-scaleup"
  scaling_adjustment = var.web_asg_capacity.min
  adjustment_type    = var.web_adjustment_type
  cooldown           = 300
  # ASG attached
  autoscaling_group_name = aws_autoscaling_group.web.name
}
//  2) CW Metric Alarm
resource "aws_cloudwatch_metric_alarm" "web_scaleup_alarm" {
  alarm_name          = "${var.env}-web-cpu-scaleup-alarm"
  alarm_description   = "This metric monitors Web ASG CPU Utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.web_cpu_scaleup_threshold
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_actions = [aws_autoscaling_policy.web_scaleup.arn]
}
// Scale Down
//  3) ASG Policy
resource "aws_autoscaling_policy" "web_scaledown" {
  name               = "${var.env}-web-cpu-scaledown"
  scaling_adjustment = "-${var.web_asg_capacity.min}"
  adjustment_type    = var.web_adjustment_type
  cooldown           = 300
  # ASG attached
  autoscaling_group_name = aws_autoscaling_group.web.name
}
//  4) Metric Alarm
resource "aws_cloudwatch_metric_alarm" "web_scaledown_alarm" {
  alarm_name          = "${var.env}-web-cpu-scaledown-alarm"
  alarm_description   = "This metric monitors Web ASG CPU Utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.web_cpu_scaledown_threshold
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_actions = [aws_autoscaling_policy.web_scaledown.arn]
}
#######################################################################################
// 2. WAS
#######################################################################################
//  1) ASG Policy
resource "aws_autoscaling_policy" "was_scaleup" {
  name               = "${var.env}-was-cpu-scaleup"
  scaling_adjustment = var.was_asg_capacity.min
  adjustment_type    = var.was_adjustment_type
  cooldown           = 300
  # ASG attached
  autoscaling_group_name = aws_autoscaling_group.was.name
}
//  2) CW Metric Alarm
resource "aws_cloudwatch_metric_alarm" "was_scaleup_alarm" {
  alarm_name          = "${var.env}-was-cpu-scaleup-alarm"
  alarm_description   = "This metric monitors Was ASG CPU Utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.was_cpu_scaleup_threshold
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.was.name
  }
  alarm_actions = [aws_autoscaling_policy.was_scaleup.arn]
}
// Scale Down
//  3) ASG Policy
resource "aws_autoscaling_policy" "was_scaledown" {
  name               = "${var.env}-was-cpu-scaledown"
  scaling_adjustment = "-${var.was_asg_capacity.min}"
  adjustment_type    = var.was_adjustment_type
  cooldown           = 300
  # ASG attached
  autoscaling_group_name = aws_autoscaling_group.was.name
}
//  4) Metric Alarm
resource "aws_cloudwatch_metric_alarm" "was_scaledown_alarm" {
  alarm_name          = "${var.env}-was-cpu-scaledown-alarm"
  alarm_description   = "This metric monitors Was ASG CPU Utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.was_cpu_scaledown_threshold
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.was.name
  }
  alarm_actions = [aws_autoscaling_policy.was_scaledown.arn]
}
// SNS
// WEB
resource "aws_autoscaling_notification" "web_asg_notification" {
  group_names = [
    aws_autoscaling_group.web.name,
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.web_asg_noti.arn
}
resource "aws_sns_topic" "web_asg_noti" {
  name = "${var.env}-web_asg-topic"
}
resource "aws_sns_topic_subscription" "web_asg_noti" {
  topic_arn = aws_sns_topic.web_asg_noti.arn
  protocol  = "email"
  endpoint  = var.asg_noti_endpoint
}
// WAS
resource "aws_autoscaling_notification" "was_asg_notification" {
  group_names = [
    aws_autoscaling_group.was.name,
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.was_asg_noti.arn
}
resource "aws_sns_topic" "was_asg_noti" {
  name = "${var.env}-was_asg-topic"
}
resource "aws_sns_topic_subscription" "was_asg_noti" {
  topic_arn = aws_sns_topic.was_asg_noti.arn
  protocol  = "email"
  endpoint  = var.asg_noti_endpoint
}