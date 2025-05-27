import json
import boto3
import logging
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

asg = boto3.client('autoscaling')
ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    try:
        logger.info(f"Received event: {json.dumps(event)}")
        message = json.loads(event['Records'][0]['Sns']['Message'])
        
        # Validating required fields
        required_fields = ['EC2InstanceId', 'AutoScalingGroupName', 'LifecycleHookName']
        missing = [field for field in required_fields if field not in message]
        if missing:
            raise ValueError(f"Missing required fields: {', '.join(missing)}")
            
        instance_id = message['EC2InstanceId']
        asg_name = message['AutoScalingGroupName']
        hook_name = message['LifecycleHookName']

        # Checking instance hibernation support
        instance_info = ec2.describe_instances(InstanceIds=[instance_id])
        hibernation_supported = instance_info['Reservations'][0]['Instances'][0]['HibernationOptions']['Configured']
        
        if not hibernation_supported:
            logger.error(f"Instance {instance_id} does not support hibernation")
            raise ValueError("Instance not configured for hibernation")

        # Sending heartbeat every 2 minutes until timeout
        asg.record_lifecycle_action_heartbeat(
            LifecycleHookName=hook_name,
            AutoScalingGroupName=asg_name,
            InstanceId=instance_id
        )

        # Attempt hibernation
        try:
            ec2.stop_instances(
                InstanceIds=[instance_id],
                Hibernate=True
            )
            logger.info(f"Successfully initiated hibernation for {instance_id}")
        except ClientError as e:
            logger.error(f"Hibernation failed: {str(e)}")
            raise

        # Complete lifecycle action after successful hibernation
        asg.complete_lifecycle_action(
            LifecycleHookName=hook_name,
            AutoScalingGroupName=asg_name,
            LifecycleActionResult='CONTINUE',  
            InstanceId=instance_id
        )
        logger.info("Lifecycle action completed successfully")

    except Exception as e:
        logger.error(f"Error: {str(e)}")
        # Force complete action to prevent stuck instances
        asg.complete_lifecycle_action(
            LifecycleHookName=hook_name,
            AutoScalingGroupName=asg_name,
            LifecycleActionResult='CONTINUE',
            InstanceId=instance_id
        )
        raise
