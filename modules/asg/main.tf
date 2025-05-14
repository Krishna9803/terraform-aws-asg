resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data != null ? base64encode(var.user_data) : null

  vpc_security_group_ids = var.security_group_ids
  ebs_optimized          = var.ebs_optimized

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      encrypted             = var.root_volume_encrypted
      delete_on_termination = var.enable_hibernation ? false : true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.name_prefix}-instance" })
  }

  hibernation_options {
    configured = var.enable_hibernation
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = "${var.name_prefix}-asg-"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns    = var.target_group_arns
  health_check_type    = var.health_check_type
  termination_policies = var.termination_policies

  dynamic "initial_lifecycle_hook" {
    for_each = var.initial_lifecycle_hooks
    content {
      name                    = initial_lifecycle_hook.value.name
      lifecycle_transition    = initial_lifecycle_hook.value.transition
      default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
      heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_arn", null)
      role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
    }
  }

  dynamic "warm_pool" {
    for_each = var.enable_hibernation ? [1] : []
    content {
      pool_state = "Hibernated"
      min_size   = var.warm_pool_min_size

      instance_reuse_policy {
        reuse_on_scale_in = true
      }
    }
  }

  dynamic "tag" {
    for_each = merge(var.tags, { Name = var.name_prefix })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes        = [desired_capacity, target_group_arns]
    create_before_destroy = true
  }
}

# SNS Topic
resource "aws_sns_topic" "lifecycle_notifications" {
  name = "${var.name_prefix}-lifecycle-topic"
}
