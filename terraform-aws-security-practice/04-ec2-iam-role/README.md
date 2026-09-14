# 04 — EC2 + IAM Role: No Access Keys, Anywhere

This was the exercise that clicked the most for me: getting an EC2 instance to read from S3 without ever storing a single credential on it.

## Why this setup instead of just using an access key

Before IAM Roles existed for EC2, the way to do this was generating an IAM user access key and hardcoding it into the instance somehow. That key never expires on its own, and it's an easy thing to leak — a lot of real AWS bill-fraud stories start with exactly that, an access key sitting in a public repo by accident.

## What's in here

- `aws_iam_role` — the `assume_role_policy` only lets `ec2.amazonaws.com` assume it, so only EC2 instances (not people) can use it
- `aws_iam_role_policy` (inline) — read-only on the one bucket, nothing else
- `aws_iam_instance_profile` — the piece that actually connects a Role to an EC2 instance (turns out you can't attach a Role directly, you need this in between)
- The instance uses `iam_instance_profile`, no access key anywhere in the config

## How I confirmed it actually worked

From inside the instance, no credentials configured manually:

```bash
# confirms it's using temporary assumed-role creds, not a fixed user
aws sts get-caller-identity
# → "Arn": ".../assumed-role/ec2-s3-read-role/<instance-id>"

# read works
aws s3 ls s3://<bucket-name>

# write correctly fails — this is the part I actually wanted to see
aws s3 cp test.txt s3://<bucket-name>/
# → AccessDenied
```

That `AccessDenied` on the write attempt was the real confirmation that least privilege wasn't just configured, it was actually being enforced.

## Screenshots

*(Terminal screenshots: `terraform apply`, the `get-caller-identity` output, and the `AccessDenied` error.)*
