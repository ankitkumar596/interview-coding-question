#!/bin/bash

# Set the AWS region
REGION="us-west-1"

# Fetch the instance IDs with the tag Environment=dev and in running state
INSTANCE_IDS=$(aws ec2 describe-instances \
    --region $REGION \
    --filters "Name=tag:Environment,Values=dev" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

# Check if any instance IDs were returned
if [ -z "$INSTANCE_IDS" ]; then
    echo "No instances with the tag Environment:dev to stop"
    exit 0
fi

# Stop the instances
aws ec2 stop-instances \
    --region $REGION \
    --instance-ids $INSTANCE_IDS

echo "Stopped your instances: $INSTANCE_IDS"
