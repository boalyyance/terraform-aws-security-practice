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

<img width="1680" height="1050" alt="terraform_init_sg" src="https://github.com/user-attachments/assets/fdb9b8e4-9beb-43e2-9d4b-07d0745fba5b" />
<img width="1680" height="1050" alt="terraform_plan_sg_1" src="https://github.com/user-attachments/assets/f2c846fd-4a93-4f5c-aca4-8b7d15c35c58" />
<img width="1680" height="1050" alt="terraform_plan_sg_2" src="https://github.com/user-attachments/assets/7c128580-a6a2-4979-9c06-bd428f66c1ee" />
<img width="1680" height="1050" alt="terraform_apply_sg_1" src="https://github.com/user-attachments/assets/4de1d71c-a51e-487a-b415-abe555945cc1" />
<img width="1680" height="1050" alt="terraform_apply_sg_2" src="https://github.com/user-attachments/assets/ce3b9e7a-6f54-470e-ba5a-da43e4918555" />
<img width="1680" height="1050" alt="ec2_connection_ssh" src="https://github.com/user-attachments/assets/851827a9-e0ac-4a20-bbff-34d7a8aca982" />
<img width="1680" height="97" alt="connection_from_another_IP_failed" src="https://github.com/user-attachments/assets/ffa927ca-9f61-4e76-809d-863a5abfdb01" />
<img width="1680" height="1050" alt="terraform_destroy_sg_1" src="https://github.com/user-attachments/assets/147b388e-56d2-4c00-8211-763dd8595cc2" />
<img width="1680" height="1050" alt="terraform_destroy_sg_2" src="https://github.com/user-attachments/assets/c4c51f41-371f-4e4d-8ee6-5b0a86821320" />
<img width="1680" height="1050" alt="terraform_destroy_sg_3" src="https://github.com/user-attachments/assets/8054b79b-8dbf-43c8-900d-5d5381c3dd9a" />

