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

<img width="1680" height="349" alt="terraform_init_s3_basic" src="https://github.com/user-attachments/assets/4f6c5234-6969-4e1d-b213-59564b0ac725" />
<img width="1680" height="617" alt="terraform_plan_s3_basic" src="https://github.com/user-attachments/assets/cce6af8f-c74a-4e80-ba3e-412a99985bb9" />
<img width="1680" height="716" alt="terraform_apply_s3_basic" src="https://github.com/user-attachments/assets/01eb0072-9466-4f00-9a76-e9fce08e6b7a" />
<img width="1680" height="72" alt="confirm_s3_created" src="https://github.com/user-attachments/assets/abe26ef7-9268-4cb3-9066-b4cf0ac81a67" />
<img width="1680" height="967" alt="terraform_destroy_s3_basic" src="https://github.com/user-attachments/assets/bbd37414-d0e3-4e64-8b9d-2f7960aa17e8" />
<img width="1680" height="134" alt="confirm_s3_destroyed" src="https://github.com/user-attachments/assets/bdbd5211-c231-4fc0-b0cd-1132e225adc4" />






