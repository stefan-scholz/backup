#!/bin/bash

# Hetzner credentials saved in the AWS CLI
export AWS_PROFILE=hetzner

# Point to the S3 bucket with region and bucket name
export RESTIC_REPOSITORY="s3:fsn1.your-objectstorage.com/personal-backup-9c27"

# Retrieve the encryption password securely from the macOS Keychain
export RESTIC_PASSWORD_COMMAND="security find-generic-password -a restic -s restic-password -w"

# Proceed with any restic commands passed to the script
restic "$@"