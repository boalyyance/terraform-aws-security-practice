# 06 — Moving to Terraform Cloud

Migrated from running everything locally to using Terraform Cloud for state — CLI-driven workflow, no VCS integration needed.

## What I did

- `terraform login` to connect the CLI to Terraform Cloud
- Added the `cloud {}` block inside `terraform {}` pointing to my organization + workspace
- Re-ran `terraform init` — this time it initialized against the remote backend instead of a local `.tfstate`
- Ran plan/apply/destroy remotely — the actual execution happens on Terraform Cloud's runners, not my machine

## The problems I actually hit (and had to fix)

Nothing about this went smoothly on the first try, which honestly taught me more than if it had just worked:

1. **`file("~/.ssh/key.pub")` broke.** Makes sense once you think about it — the remote runner has no idea my local filesystem exists. Fixed it by pasting the public key directly as a string instead (it's not a secret, so that's fine).
2. **My local AWS credentials weren't there either.** Got `No valid credential sources found` because the runner can't see `~/.aws/credentials`. Had to add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables directly in the Terraform Cloud workspace (marked the secret one as "Sensitive").
3. **Version mismatch.** The remote runner was on a newer Terraform version than my local CLI. Changed `required_version` from an exact pin to `">= 1.5.7"` so both sides are happy.

## Why this actually matters, not just "because Terraform Cloud is a thing"

With state stored remotely, every plan/apply gets logged — the Runs tab shows the full history, including the failed attempts above, so nothing gets silently lost the way it would if it only lived on my laptop. That's the real answer to "why does it matter where state lives for a team" — I didn't just read that, I ran into the actual problems it solves.

## Screenshots

*(Terminal screenshots: `terraform login` success, `init` showing "Terraform Cloud has been successfully initialized!", the Runs history, and the state list with the `module.practice_bucket.` prefix.)*
