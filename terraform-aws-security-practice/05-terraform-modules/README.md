# 05 — Turning the S3 Setup Into a Module

Took the hardened S3 bucket from exercise 02 and refactored it into a module so I wouldn't have to copy-paste the same 4 resources every time I need a secure bucket somewhere else.

## What's in here

- `variables.tf` — inputs the module takes (`bucket_name` required, `environment` optional)
- `main.tf` — the actual resources, using `var.bucket_name` instead of a hardcoded name, named `this` (that's just the convention inside a module)
- `outputs.tf` — what the module exposes back out (`bucket_arn`, `bucket_id`)
- Root `main.tf` calls it with `module "practice_bucket" { source = "./modules/secure-s3-bucket" ... }`

## Why I bothered

If I ever need this same secure bucket setup in another project, copy-pasting the same 4 resources is exactly how mistakes creep in — someone forgets to add the encryption block, or fat-fingers a flag. A module means I only maintain the security config in one place.

## Something worth knowing for later

Using a module doesn't create a separate state file — everything's still in one state, but resources from a module get prefixed with `module.<name>.` (like `module.practice_bucket.aws_s3_bucket.this`) so Terraform can tell them apart from anything else.

## Screenshots

*(Terminal screenshots: `terraform init` showing "Initializing modules...", and `plan` showing the `module.practice_bucket.` prefix.)*
