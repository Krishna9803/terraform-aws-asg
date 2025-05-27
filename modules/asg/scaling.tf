resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.name_prefix}-scale-up"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.name_prefix}-scale-down"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name


}


resource "aws_autoscaling_policy" "target_tracking" {
  name                   = "${var.name_prefix}-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name

  target_tracking_configuration {
    target_value = 40.0 
    disable_scale_in = false

    customized_metric_specification {
      metric_name = "CPUUtilization"
      namespace   = "AWS/EC2"
      statistic   = "Average"
    }
  }
}
