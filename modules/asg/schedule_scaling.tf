resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "${var.name_prefix}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  min_size               = var.schedule_scale_up_min
  max_size               = var.schedule_scale_up_max
  desired_capacity       = var.schedule_scale_up_desired
  recurrence             = var.schedule_scale_up_recurrence
}

resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "${var.name_prefix}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  min_size               = var.schedule_scale_down_min
  max_size               = var.schedule_scale_down_max
  desired_capacity       = var.schedule_scale_down_desired
  recurrence             = var.schedule_scale_down_recurrence
}
