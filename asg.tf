provider "aws" {
  region = "us-east-1"
}

module "autoscaling" {
  source = "./modules/asg"

  name_prefix        = "test-asg"
  image_id           = "ami-40128086412120"
  instance_type      = "t3.micro"
  security_group_ids = ["sg-1234567890abcdef0"]
  subnet_ids         = ["subnet-12345", "subnet-67890"]

  min_size         = 2
  max_size         = 5
  desired_capacity = 3

  #   cpu_scale_up_threshold   = 70
  #   cpu_scale_down_threshold = 30

  #   schedule_scale_up_recurrence   = "0 9 * * MON-FRI"
  #   schedule_scale_down_recurrence = "0 18 * * MON-FRI"

  # Optional: Attach to a Load Balancer Target Group
  target_group_arns = ["arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-tg/abcdef1234567890"]

  # Optional: User data
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from ASG" > /tmp/asg.txt
  EOF

  key_name = "my-keypair"

  # Optional: EBS settings
  ebs_optimized         = false
  root_volume_size      = 20
  root_volume_type      = "gp3"
  root_volume_encrypted = true

  # Optional: Health checks and termination
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]

  # Optional: Lifecycle hooks
  initial_lifecycle_hooks = [
    {
      name              = "launch-wait"
      transition        = "autoscaling:EC2_INSTANCE_LAUNCHING"
      default_result    = "CONTINUE"
      heartbeat_timeout = 300
    }
  ]

  # Optional: Scaling policies thresholds
  cpu_scale_up_threshold   = 70
  cpu_scale_down_threshold = 30

  # Optional: Scheduled scaling
  schedule_scale_up_min        = 2
  schedule_scale_up_max        = 4
  schedule_scale_up_desired    = 3
  schedule_scale_up_recurrence = "0 9 * * MON-FRI"

  schedule_scale_down_min        = 1
  schedule_scale_down_max        = 2
  schedule_scale_down_desired    = 1
  schedule_scale_down_recurrence = "0 18 * * MON-FRI"

  # Optional: Hibernation and warm pool
  enable_hibernation = false
  warm_pool_min_size = 1

  # Optional: Tags
  tags = {
    Environment = "dev"
    Project     = "asg-demo"
  }
}




