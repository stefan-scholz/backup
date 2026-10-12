# Backup

> Manage personal backups

## Prerequisites

You will need a Hetzner Cloud account with an Object Storage bucket created, and an S3 Access Key and Secret Key generated.

Install the required command-line tools using Homebrew:

```bash
brew install awscli restic
```

## Installation

Instead of passing credentials in plain text, we use a dedicated AWS profile to authenticate with Hetzner.

1. Run the configuration wizard to create a profile named hetzner:

```bash
aws configure --profile hetzner
```

- AWS Access Key ID: [paste your Hetzner Access Key]
- AWS Secret Access Key: [paste your Hetzner Secret Key]
- Default region name: [leave blank]
- Default output format: [leave blank]

2. Add your Hetzner endpoint to the AWS config file. Open ~/.aws/config

```bash
nano ~/.aws/config
```

3. Add the endpoint_url corresponding to your bucket's region directly under the [profile hetzner] block:

```
[profile hetzner]
endpoint_url = https://fsn1.your-objectstorage.com
```

To avoid writing your Restic encryption password in a script or typing it manually every time, store it securely in the macOS Keychain.

Run the following command, replacing "your_password" with your highly secure repository password:

```bash
security add-generic-password -a "restic" -s "restic-password" -w "your_password"
```

*Note: The first time Restic attempts to read this password, macOS will prompt you to allow the Terminal/script to access the Keychain. Click Always Allow.*

To run Restic commands seamlessly, create a wrapper script or set these environment variables in your terminal before running commands.

Make the script executable:

```bash
chmod +x scripts/backup.sh
```

## Operations

With the setup complete, you can now manage your backups.

### Initialize the Repository (Run Once)

Before you can back up data, you must initialize the repository to create the encrypted folder structure in your Hetzner bucket.

```bash
./scripts/backup.sh init
```

### Run a Backup

To back up a directory (e.g., your Documents folder), point the backup command to the target path. Restic will automatically chunk, deduplicate, encrypt, and upload the data.

```bash
./scripts/backup.sh backup ~ --exclude-file configs/excludes.txt
```

### Retention Policy & Cleanup (Forget and Prune)

To keep your storage costs down, use a retention policy to delete old backups and prune to free up the physical storage space in the Hetzner bucket.

This command deletes snapshots older than 30 days, but strictly guarantees that the 5 most recent snapshots are kept regardless of age.

```bash
./scripts/backup.sh forget --keep-within 30d --keep-last 5 --prune
```

### Restore Files

To restore the most recent backup of your files to a new recovery folder:

```bash
./scripts/backup.sh restore latest --target ~/Desktop/RecoveredDocuments
```
