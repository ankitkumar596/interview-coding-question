#!/bin/bash

# Variables
SOURCE_DIR="/usr/share"  # Local directory to back up
S3_BUCKET="s3://myawsbucket04082024/backup/"  # S3 bucket name and path
LOG_FILE="/var/log/s3_backup.log"  # Log file path
DATE=$(date '+%Y-%m-%d')  # Current date for backup folder

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory $SOURCE_DIR does not exist. Exiting."
  exit 1
fi

# Perform the backup using the AWS CLI
echo "Starting backup: $(date)" >> "$LOG_FILE"
aws s3 sync "$SOURCE_DIR" "$S3_BUCKET/$DATE" --delete >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
  echo "Backup completed successfully: $(date)" >> "$LOG_FILE"
else
  echo "Backup failed: $(date)" >> "$LOG_FILE"
  exit 1
fi

# Print a message indicating the script has finished
echo "Backup process completed. Check $LOG_FILE for details."
