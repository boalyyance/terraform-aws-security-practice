# 05 — Refactoring into a Reusable Terraform Module

Takes the hardened S3 bucket from exercise 02 and refactors it into a reusable **module** — the Terraform equivalent of a function.

## What this covers

- `variables.tf` — the module's inputs (`bucket_name` required, `environment` optional with a default)
- `main.tf` — the resource definitions, using `var.bucket_name` instead of a hardcoded string, and named `this` (convention for resources inside a module)
- `outputs.tf` — what the module exposes to whatever calls it (`bucket_arn`, `bucket_id`)
- The root `main.tf` calls the module with `module "practice_bucket" { source = "./modules/secure-s3-bucket" ... }`

## Why this matters

Without modules, reusing the same secure S3 configuration across multiple projects means copy-pasting the same 4 resources every time — and copy-pasted security configuration is exactly how drift and mistakes creep in. A module packages the configuration once; calling it twice with different `bucket_name` values produces two independently secure buckets from a single source of truth.

## Resource/module vs. state — a common interview question

Using a module doesn't create a separate state file. Terraform Cloud/local state stores module resources with a `module.<name>.` prefix (e.g., `module.practice_bucket.aws_s3_bucket.this`), distinguishing them from root-level resources — but everything still lives in one state.

## Screenshots

*(Add terminal screenshots here: `terraform init` showing "Initializing modules...", and `terraform plan` showing the `module.practice_bucket.` prefix on each resource.)*
