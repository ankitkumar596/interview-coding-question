#!/bin/bash

# Variables
SOURCE_DIR="/"  # Directory to back up
DEST_DIR="/home/lenevo/backup"  # Backup destination directory
LOG_FILE="/var/log/local_backup.log"  # Log file path
DATE=$(date '+%Y-%m-%d_%H-%M-%S')  # Timestamp for backup folder

# Create the destination directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
  echo "Destination directory $DEST_DIR does not exist. Creating it."
  mkdir -p "$DEST_DIR"
fi

# Perform the backup using rsync
echo "Starting backup: $(date)" >> "$LOG_FILE"
rsync -av --delete "$SOURCE_DIR/" "$DEST_DIR/$DATE/" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
  echo "Backup completed successfully: $(date)" >> "$LOG_FILE"
else
  echo "Backup failed: $(date)" >> "$LOG_FILE"
  exit 1
fi

# Print a message indicating the script has finished
echo "Backup process completed. Check $LOG_FILE for details."
