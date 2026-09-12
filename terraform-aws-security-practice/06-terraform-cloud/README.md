# 06 — Migrating to Terraform Cloud (Remote State)

Migrates the local Terraform workflow to **Terraform Cloud**, moving state management off a local machine and into a centralized, auditable remote backend — using the CLI-driven workflow (no VCS integration required).

## What this covers

- `terraform login` — authenticate the CLI with Terraform Cloud
- The `cloud {}` block inside `terraform {}` — connects a local working directory to a specific organization + workspace
- Re-running `terraform init` — this time initializing against the remote backend instead of a local `.tfstate` file
- Running `plan`/`apply`/`destroy` remotely — the actual Terraform execution happens on Terraform Cloud's own runners, not on the local machine

## Real issues hit during migration (and why they matter)

Moving to a remote execution environment surfaces problems that don't exist when running fully local — all genuine learning moments, not scripted:

1. **Local file references break.** `public_key = file("~/.ssh/key.pub")` failed remotely — the remote runner has no access to a local filesystem. Fixed by passing the public key directly as a string (safe, since public keys aren't secrets).
2. **Local AWS credentials don't carry over.** `No valid credential sources found` — the remote runner doesn't have access to `~/.aws/credentials`. Fixed by adding `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as **environment variables** in the Terraform Cloud workspace (the secret marked "Sensitive," so it's write-only after saving).
3. **Terraform version mismatch.** The remote runner used a newer Terraform version than the local CLI. Fixed by relaxing `required_version` to `">= 1.5.7"` instead of pinning an exact version.

## Why this matters for a team environment

With state stored remotely: every plan/apply is logged (the **Runs** tab shows a full history, including failed attempts — nothing is silently lost the way it would be on a single laptop), and the state itself can't be edited by two people simultaneously without locking. This is the direct answer to "why does state location matter for a team," a common interview question.

## Screenshots

*(Add terminal screenshots here: `terraform login` success, `terraform init` showing "Terraform Cloud has been successfully initialized!", the Runs history in the Terraform Cloud UI, and the state resource list showing the `module.practice_bucket.` prefix.)*
