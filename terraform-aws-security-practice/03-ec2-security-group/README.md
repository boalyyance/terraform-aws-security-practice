# 03 — EC2 + Security Group: Network Hardening, Tested Both Ways

Provisions an EC2 instance with a Security Group locked down to a single IP address, then **actively tests** that the restriction works — in both directions.

## What this covers

- `aws_key_pair` — registers a locally-generated SSH public key with AWS (the private key never leaves the local machine, and is excluded from this repo via `.gitignore`)
- `aws_security_group` — inbound rule restricted to `<my-ip>/32` on port 22 only; a `/32` CIDR means "this exact IP, no others" (versus a `/24`, which would allow an entire 256-address range)
- `aws_instance` — a `t3.micro` EC2 instance using both the key pair and the security group

## Verification — the part that matters most

Configuring a firewall rule is not the same as confirming it works. Both sides were tested:

1. **Positive test:** connected via SSH from the whitelisted IP — succeeded
   ```bash
   ssh -i ~/.ssh/terraform-practice-key ec2-user@<instance-public-ip>
   ```
2. **Negative test:** switched to a different network (mobile hotspot, different public IP) and attempted the same connection — the connection **hung with no response** (AWS Security Groups silently `DROP` unauthorized traffic rather than actively rejecting it, so no packets ever get a reply)

This two-sided verification is what separates "I configured a Security Group" from "I confirmed the Security Group actually enforces what I intended."

## Instance type note

The AMI/instance type combination may need adjusting depending on which instance types are Free Tier–eligible for a given AWS account — check with:
```bash
aws ec2 describe-instance-types --filters "Name=free-tier-eligible,Values=true" --query "InstanceTypes[].InstanceType" --output table
```

## Screenshots

*(Add terminal screenshots here: `terraform plan`/`apply` output, the successful SSH connection, and the hung connection attempt from a different network.)*
