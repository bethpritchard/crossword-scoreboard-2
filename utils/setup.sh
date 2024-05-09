#!/bin/bash

# This script creates the S3 bucket and DynamoDB table required for the Terraform backend.
# When running this script, you will need to exit Vim using :q after each bucket and table creation

AWS_REGION="eu-west-2"

S3_BUCKET_NAME="crossword-scoreboard-state"
DYNAMODB_TABLE_NAME="crossword-scoreboard-state-lock"
APP="crossword-scoreboard"

check_exit_status() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

echo "Creating S3 bucket: $S3_BUCKET_NAME"
aws s3api create-bucket \
    --bucket $S3_BUCKET_NAME   \
    --region $AWS_REGION                             \
    --create-bucket-configuration LocationConstraint=$AWS_REGION
aws s3api put-bucket-versioning \
    --bucket $S3_BUCKET_NAME \
    --versioning-configuration Status=Enabled
aws s3api put-bucket-tagging \
    --bucket $S3_BUCKET_NAME \
    --tagging "TagSet=[{Key=project,Value=$APP}]"
check_exit_status "Failed to create S3 bucket: $S3_BUCKET_NAME"

echo "Creating DynamoDB table: $DYNAMODB_TABLE_NAME"
aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --tags Key=project,Value=$APP  \
    --region $AWS_REGION

echo "Waiting for DynamoDB table creation to complete..."
aws dynamodb wait table-exists --table-name $DYNAMODB_TABLE_NAME --region $AWS_REGION
check_exit_status "Failed to create DynamoDB table: $DYNAMODB_TABLE_NAME"

echo "S3 backend setup complete 🎉"