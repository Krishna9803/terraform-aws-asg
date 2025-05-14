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
        
        required_fields = ['EC2InstanceId', 'AutoScalingGroupName', 'LifecycleHookName']
        missing = [field for field in required_fields if field not in message]
        if missing:
            raise ValueError(f"Missing required fields: {', '.join(missing)}")
            
        instance_id = message['EC2InstanceId']
        asg_name = message['AutoScalingGroupName']
        hook_name = message['LifecycleHookName']

        # Verify instance state
        instance = ec2.describe_instances(InstanceIds=[instance_id])
        state = instance['Reservations'][0]['Instances'][0]['State']['Name']
        if state != 'running':
            logger.error(f"Instance {instance_id} is in {state} state, skipping")
            return

        # Attempt hibernation with retries
        for attempt in range(3):
            try:
                ec2.stop_instances(
                    InstanceIds=[instance_id],
                    Hibernate=True,
                    DryRun=False  # Remove after testing
                )
                logger.info(f"Successfully hibernated {instance_id}")
                break
            except ClientError as e:
                if e.response['Error']['Code'] == 'DryRunOperation':
                    logger.warning("Dry run succeeded")
                    break
                if attempt == 2:
                    raise
                logger.warning(f"Attempt {attempt+1} failed: {e}")
                continue

        # Complete lifecycle action
        asg.complete_lifecycle_action(
            LifecycleHookName=hook_name,
            AutoScalingGroupName=asg_name,
            LifecycleActionResult='ABANDON',
            InstanceId=instance_id
        )
        logger.info("Lifecycle action abandoned successfully")

    except Exception as e:
        logger.error(f"Critical error: {str(e)}")
        raise
