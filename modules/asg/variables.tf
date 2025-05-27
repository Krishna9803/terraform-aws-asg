variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "image_id" {
  description = "AMI ID for instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for ASG"
  type        = list(string)
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Initial desired capacity"
  type        = number
  default     = 3
}

variable "target_group_arns" {
  description = "ALB/NLB target group ARNs"
  type        = list(string)
  default     = []
}

variable "initial_lifecycle_hooks" {
  description = "List of lifecycle hook configurations"
  type = list(object({
    name              = string
    transition        = string
    default_result    = optional(string)
    heartbeat_timeout = optional(number)
    notification_arn  = optional(string)
    role_arn          = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "User data script for EC2 instances"
  type        = string
  default     = null # Optional default value
}

variable "key_name" {
  description = "The EC2 key pair name for SSH access"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "Whether the EC2 instance is EBS-optimized"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of root volume (e.g., gp3, gp2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "health_check_type" {
  description = "Health check type for ASG (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "termination_policies" {
  description = "List of termination policies for ASG"
  type        = list(string)
  default     = ["Default"]
}

variable "enable_hibernation" {
  description = "Enable instance hibernation on scale-in"
  type        = bool
  default     = false
}

variable "warm_pool_min_size" {
  description = "Minimum number of instances to keep in warm pool"
  type        = number
  default     = 1
}


variable "region" {
  description = "The region in which we are creating the auto scaling group"
  type        = string
  default     = "us-east-1"
}
