# 01 — S3 Basics: First Terraform Cycle

The first exercise: learning the core Terraform workflow end to end with the simplest possible resource.

## What this covers

- `terraform init` — download the AWS provider
- `terraform plan` — preview changes before touching real infrastructure
- `terraform apply` — create the resource
- Verification via both the AWS Console and AWS CLI (`aws s3 ls`)
- `terraform destroy` — tear down cleanly, confirmed by re-checking `aws s3 ls`

## Why this matters

Before adding any security configuration, this exercise validates the full lifecycle: nothing gets created or destroyed by accident, and every step is confirmed against real AWS state — not assumed from the Terraform output alone.

## Commands used

```bash
terraform init
terraform plan
terraform apply
aws s3 ls
terraform destroy
aws s3 ls   # confirms the bucket no longer exists
```

## Screenshots

*(Add terminal screenshots here: `terraform plan` output, `terraform apply` output, and the `aws s3 ls` confirmation before/after destroy.)*
