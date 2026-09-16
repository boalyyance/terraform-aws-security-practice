# 03 — EC2 + Security Group: Tested From Both Sides

Spun up an EC2 instance with a Security Group locked to my own IP, then actually tested that the restriction worked — not just that it looked right in the plan.

## What's in here

- `aws_key_pair` — registers a public SSH key I generated locally (private key never leaves my machine, excluded from this repo via `.gitignore`)
- `aws_security_group` — port 22 only, locked to my own IP with a /32
- `aws_instance` — a `t3.micro` using both the key pair and the security group

## The part that actually mattered: testing it both ways

1. **From my whitelisted IP** — connected fine:
```bash
   ssh -i ~/.ssh/terraform-practice-key ec2-user@<instance-public-ip>
```
2. **From a different network** — switched to a mobile hotspot and tried the same command. It just hung, no response. AWS Security Groups silently drop unauthorized traffic instead of rejecting it, so there's no error, just... nothing.

That second test is the one that actually proves the rule works. Configuring the Security Group is easy; confirming it blocks what it's supposed to block is the part that matters.

## One gotcha

The AMI/instance type combo might need adjusting depending on what's Free Tier–eligible for a given account:
```bash
aws ec2 describe-instance-types --filters "Name=free-tier-eligible,Values=true" --query "InstanceTypes[].InstanceType" --output table
```

## Screenshots

*(Terminal screenshots: plan/apply output, the successful SSH connection, and the hung connection attempt from the other network.)*
