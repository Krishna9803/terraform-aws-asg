## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_autoscaling"></a> [autoscaling](#module\_autoscaling) | ./modules/asg | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | The name of the Auto Scaling Group. |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | The ARN of the Auto Scaling Group. |
| <a name="output_launch_template"></a> [launch\_template](#output\_launch\_template) | The ID of the Launch Template used by the ASG. |
| <a name="output_sns_topic"></a> [sns\_topic](#output\_sns\_topic) | The ARN of the SNS topic for lifecycle notifications. |
