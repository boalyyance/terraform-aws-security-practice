# 02 — S3 Hardening + Least-Privilege IAM

This one builds on the basic bucket by adding actual security controls, plus a scoped-down IAM user. First time I really applied least privilege instead of just reading about it.

## What's in here

**S3 hardening:**
- `aws_s3_bucket_public_access_block` — all 4 flags on `true`, so there's no accidental way this bucket becomes public
- `aws_s3_bucket_server_side_encryption_configuration` — AES256 encryption at rest
- `aws_s3_bucket_versioning` — so an accidental overwrite or delete doesn't just wipe the data

**IAM:**
- A test user with a policy that only allows `s3:GetObject` and `s3:ListBucket` — no write, no delete, scoped to this one bucket's ARN, not `*`

## How I verified it

I didn't just trust the Terraform plan — checked the actual AWS state via CLI:

```bash
aws s3api get-public-access-block --bucket <bucket-name>
aws s3api get-bucket-encryption --bucket <bucket-name>
aws s3api get-bucket-versioning --bucket <bucket-name>
aws iam list-attached-user-policies --user-name terraform-test-user
```

## One thing I noticed about references

Every security resource points back to the bucket with `aws_s3_bucket.practice_bucket.id` or `.arn` instead of a hardcoded name. That's what let Terraform figure out the create order on its own (bucket first, then its configs, then the IAM policy that needs the ARN) — and destroy everything in the reverse order without me telling it to.

## Screenshots

*(Terminal screenshots: `terraform plan` with 7 resources, the CLI checks and their output, `terraform destroy`.)*
