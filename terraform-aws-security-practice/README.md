# AWS + Terraform — Cloud Security Practice

I built this while working through a mentor-guided track after getting my AWS Cloud Practitioner cert. The goal wasn't just to get things running in AWS — it was to actually break/test what I built and confirm the security controls held up, not just assume the config was right because `terraform apply` didn't error out.

**Background:** [Google Cybersecurity Certificate](https://www.coursera.org/) · [AWS Certified Cloud Practitioner (CLF-C02)](https://www.credly.com/) — currently applying to entry-level Cloud Security roles.

## What I practiced here

- Locking down IAM to least privilege and actually confirming the `AccessDenied` shows up when it should
- S3 hardening — blocking public access, encryption, versioning
- EC2 with a Security Group scoped to my own IP, tested from a different network to make sure it actually blocked me
- Getting an EC2 instance to read from S3 with zero access keys involved, using an IAM Role instead
- Moving my Terraform state from local to Terraform Cloud
- Turning the S3 setup into a reusable module
- Importing a manually-created bucket into Terraform to see how that workflow works

## Defense in depth, tested layer by layer

![Defense in Depth diagram](./defense-in-depth.svg)

1. **Network** — Security Group, SSH only from my IP (confirmed it drops connections from anywhere else)
2. **Auth** — SSH key pair, private key stays on my machine
3. **Identity** — IAM Role, read-only on S3 (confirmed `PutObject` gets denied)
4. **Data** — S3 with public access blocked, encrypted, versioned

## Exercises

| Folder | What's in it |
|---|---|
| [`01-s3-basico`](./01-s3-basico) | First full Terraform cycle — init, plan, apply, destroy — on a single bucket |
| [`02-s3-iam-seguridad`](./02-s3-iam-seguridad) | IAM user with a read-only policy, plus S3 hardening |
| [`03-ec2-security-group`](./03-ec2-security-group) | EC2 + Security Group locked to one IP, tested both ways |
| [`04-ec2-iam-role`](./04-ec2-iam-role) | EC2 reading S3 through an IAM Role instead of access keys |
| [`05-terraform-modules`](./05-terraform-modules) | Refactored the S3 setup into a module |
| [`06-terraform-cloud`](./06-terraform-cloud) | Moved state from local to Terraform Cloud |

## Tools

Terraform, AWS CLI, AWS IAM/S3/EC2, SSH.

## Notes

Everything here got destroyed after each exercise so nothing kept running/costing money. No real IPs, account IDs, or credentials in this repo — check `.gitignore`.
