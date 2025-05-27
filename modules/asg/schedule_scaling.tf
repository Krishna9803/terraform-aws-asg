resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "${var.name_prefix}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  # Hardcoded values
  min_size         = 2
  max_size         = 4
  desired_capacity = 3
  recurrence       = "0 9 * * MON-FRI"  # Mon-Fri 9 AM UTC
}

resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "${var.name_prefix}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  # Hardcoded values
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  recurrence       = "0 18 * * MON-FRI"  # Mon-Fri 6 PM UTC
}

