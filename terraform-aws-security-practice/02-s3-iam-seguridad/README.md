# 02 — S3 Hardening + Least-Privilege IAM

Builds on the basic S3 bucket by adding real security controls, plus a scoped IAM user — the first hands-on application of the **least privilege principle**.

## What this covers

**S3 hardening (3 layers):**
- `aws_s3_bucket_public_access_block` — all 4 flags set to `true`, blocking any possibility of accidental public exposure (the #1 cause of real-world cloud data breaches)
- `aws_s3_bucket_server_side_encryption_configuration` — AES256 encryption at rest
- `aws_s3_bucket_versioning` — protects against accidental deletion or ransomware-style overwrites

**Least-privilege IAM:**
- A dedicated IAM user with a policy granting **only** `s3:GetObject` and `s3:ListBucket` — no write, no delete, and scoped to this one bucket's ARN, not `*`

## Verification (not just configuration)

Every control was checked against real AWS state via CLI, not assumed from the Terraform plan alone:

```bash
aws s3api get-public-access-block --bucket <bucket-name>
aws s3api get-bucket-encryption --bucket <bucket-name>
aws s3api get-bucket-versioning --bucket <bucket-name>
aws iam list-attached-user-policies --user-name terraform-test-user
```

## Why references matter here

Every security-config resource points back to the bucket using `aws_s3_bucket.practice_bucket.id` or `.arn` — not a hardcoded bucket name. This means Terraform automatically builds the correct dependency graph (bucket created first, then its security configs, then the IAM policy that references its ARN) and destroys everything in the reverse order automatically.

## Screenshots


