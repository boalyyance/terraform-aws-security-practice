# 01 — S3 Basics: First Terraform Cycle

My first real exercise with Terraform — just getting the basic workflow down before touching anything security-related.

## What I did

- `terraform init` to pull the AWS provider
- `terraform plan` to see what it was going to do before actually doing it
- `terraform apply` to create the bucket
- Checked it existed both in the AWS Console and with `aws s3 ls`
- `terraform destroy` to tear it down, then confirmed with `aws s3 ls` again that it was actually gone

## Why I started here

Before adding any security config, I wanted to make sure I trusted the full cycle — that nothing gets created or destroyed unexpectedly, and that I'm not just trusting Terraform's output, I'm checking against real AWS state myself.

## Commands

```bash
terraform init
terraform plan
terraform apply
aws s3 ls
terraform destroy
aws s3 ls   # confirms the bucket is gone
```

## Screenshots

*(Adding terminal screenshots here — plan output, apply output, and the before/after `aws s3 ls`.)*
