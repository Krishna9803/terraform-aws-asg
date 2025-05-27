provider "aws" {
  region     = "us-east-1"
  access_key = "*********************"
  secret_key = "***************************************"
}

module "autoscaling" {
  source = "./modules/asg"

  name_prefix        = "test-asg"
  image_id           = "ami-0953476d60561c955"
  instance_type      = "t3.micro"
  security_group_ids = ["sg-043a1188ef4814999"]
  subnet_ids = [
    "subnet-0cb91dabc10a32bd5", # public - us-east-1a
    "subnet-0bcd7932ffa8ffa51",  # us-east-1b, public
  ]
  min_size         = 2
  max_size         = 5
  desired_capacity = 3

  ######
  # # Optional: Attach to a Load Balancer Target Group
  # target_group_arns = ["arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-tg/abcdef1234567890"]

  # # Optional: User data
  # user_data = <<-EOF
  #   #!/bin/bash
  #   echo "Hello from ASG" > /tmp/asg.txt
  # EOF

  # key_name = "my-keypair"

  # Optional: EBS settings
  ebs_optimized         = false
  root_volume_size      = 20
  root_volume_type      = "gp3"
  root_volume_encrypted = true

  # Optional: Health checks and termination
  health_check_type    = "EC2"
  termination_policies = ["OldestLaunchTemplate"]

  # # Optional: Lifecycle hooks
  # initial_lifecycle_hooks = [
  #   {
  #     name              = "launch-wait"
  #     transition        = "autoscaling:EC2_INSTANCE_LAUNCHING"
  #     default_result    = "CONTINUE"
  #     heartbeat_timeout = 300
  #   }
  # ]

  # Optional: Hibernation and warm pool
  enable_hibernation = false
  warm_pool_min_size = 1

  # Optional: Tags
  tags = {
    Environment = "dev"
    Project     = "asg-demo"
  }
}
