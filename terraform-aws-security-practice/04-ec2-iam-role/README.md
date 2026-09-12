# 04 — EC2 + IAM Role: Credential-Free Service Access

The centerpiece exercise: an EC2 instance that reads from S3 **without ever storing an access key**, using temporary, auto-rotating credentials instead.

## The problem this solves

Before IAM Roles existed for EC2, granting an instance access to another AWS service meant generating a long-lived IAM user access key and hardcoding it into the instance (via `user_data`, a config file, or environment variables). That access key:
- Never expires on its own
- Is easy to leak (a common real-world cause of major AWS bill fraud is exactly this pattern committed accidentally to a public GitHub repo)

## What this covers

- `aws_iam_role` with an `assume_role_policy` scoped to `ec2.amazonaws.com` only — defining **who** can assume the role
- `aws_iam_role_policy` (inline) granting only `s3:GetObject` and `s3:ListBucket` on this one bucket — defining **what** the role can do
- `aws_iam_instance_profile` — the required bridge between an IAM Role and an EC2 instance
- The EC2 instance references `iam_instance_profile`, not any access key

## Verification — proving there are no credentials, and that permissions are actually enforced

From inside the instance, with zero AWS credentials configured manually:

```bash
# Confirms the instance is using temporary, assumed-role credentials — not a fixed IAM user
aws sts get-caller-identity
# → "Arn": "arn:aws:sts::<account-id>:assumed-role/ec2-s3-read-role/<instance-id>"

# Confirms read access works
aws s3 ls s3://<bucket-name>

# Confirms write access is correctly DENIED (least privilege in the other direction)
aws s3 cp test.txt s3://<bucket-name>/
# → An error occurred (AccessDenied) when calling the PutObject operation
```

That `AccessDenied` response is the proof that least privilege isn't just configured — it's enforced.

## Screenshots

*(Add terminal screenshots here: `terraform apply` output, the `get-caller-identity` result showing `assumed-role`, and the `AccessDenied` error on `PutObject`.)*
