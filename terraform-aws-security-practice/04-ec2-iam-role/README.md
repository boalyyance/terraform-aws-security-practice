# 04 — EC2 + IAM Role: No Access Keys, Anywhere

This was the exercise that clicked the most for me: getting an EC2 instance to read from S3 without ever storing a single credential on it.

## Why this setup instead of just using an access key

Before IAM Roles existed for EC2, the way to do this was generating an IAM user access key and hardcoding it into the instance somehow. That key never expires on its own, and it's an easy thing to leak — a lot of real AWS bill-fraud stories start with exactly that, an access key sitting in a public repo by accident.

## What's in here

- `aws_iam_role` — the `assume_role_policy` only lets `ec2.amazonaws.com` assume it, so only EC2 instances (not people) can use it
- `aws_iam_role_policy` (inline) — read-only on the one bucket, nothing else
- `aws_iam_instance_profile` — the piece that actually connects a Role to an EC2 instance (turns out you can't attach a Role directly, you need this in between)
- The instance uses `iam_instance_profile`, no access key anywhere in the config

## How I confirmed it actually worked

From inside the instance, no credentials configured manually:

```bash
# confirms it's using temporary assumed-role creds, not a fixed user
aws sts get-caller-identity
# → "Arn": ".../assumed-role/ec2-s3-read-role/<instance-id>"

# read works
aws s3 ls s3://<bucket-name>

# write correctly fails — this is the part I actually wanted to see
aws s3 cp test.txt s3://<bucket-name>/
# → AccessDenied
```

That `AccessDenied` on the write attempt was the real confirmation that least privilege wasn't just configured, it was actually being enforced.

## Screenshots

<img width="1660" height="873" alt="terraform_init_04" src="https://github.com/user-attachments/assets/d1e901ee-f697-44b5-a8d6-1a1872874499" />
<img width="1680" height="1050" alt="terraform_plan_04_1" src="https://github.com/user-attachments/assets/3ee9de3a-4fdc-4878-954e-1b5a7c8e4c3a" />
<img width="1680" height="1050" alt="terraform_plan_04_2" src="https://github.com/user-attachments/assets/7b64fc7d-6556-42ee-90e9-53471764a2ce" />
<img width="1680" height="1050" alt="terraform_plan_04_3" src="https://github.com/user-attachments/assets/bfec6708-e60b-4bba-b943-91cbaf3391c1" />
<img width="1680" height="1050" alt="terraform_apply_1" src="https://github.com/user-attachments/assets/25156080-c111-4251-bc9b-de85a247046d" />
<img width="1680" height="1050" alt="apply-2" src="https://github.com/user-attachments/assets/709bb0bd-4127-4bc3-b291-5e919047030c" />
<img width="1680" height="1050" alt="apply-3" src="https://github.com/user-attachments/assets/c42d1bdb-692e-4f06-b9f4-6b795e88bc0c" />
<img width="1680" height="1050" alt="terraform_apply_4" src="https://github.com/user-attachments/assets/c9225da1-3f33-4da6-8fd5-be3509b9abc8" />
<img width="1680" height="1050" alt="get_ec2_public_IP" src="https://github.com/user-attachments/assets/b5def759-6333-4dee-b654-810f24b92cc1" />
<img width="1680" height="1050" alt="ssh_connection_EC2" src="https://github.com/user-attachments/assets/013c7f21-559e-45fd-9365-7762ae37c360" />
<img width="1680" height="233" alt="confirming_IAM_Role_Credentials_on_EC2" src="https://github.com/user-attachments/assets/48396e23-e295-4f15-900a-acb225b4fd35" />
<img width="1680" height="202" alt="proving_ListBucket-rol-permission-worked" src="https://github.com/user-attachments/assets/619ccac0-f83f-4c16-8b55-1bd3868cce53" />
<img width="1680" height="251" alt="ListBucket_GetObjetc_EC2_role_permission_2" src="https://github.com/user-attachments/assets/b764ea19-5ad8-4283-b281-de08fff734ef" />
<img width="1680" height="86" alt="confirming_role_not_allowed_to_PutObject_just_read" src="https://github.com/user-attachments/assets/38e6e1a8-2827-46e7-9cca-a12c88a0e6e6" />


