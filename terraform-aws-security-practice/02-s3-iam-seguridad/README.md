# 02 — S3 Hardening + Least-Privilege IAM

This one builds on the basic bucket by adding actual security controls, plus a scoped-down IAM user. First time I really applied least privilege instead of just reading about it.

## What's in here

**S3 hardening:**
- `aws_s3_bucket_public_access_block` — all 4 flags on `true`, so there's no accidental way this bucket becomes public
- `aws_s3_bucket_server_side_encryption_configuration` — AES256 encryption at rest
- `aws_s3_bucket_versioning` — so an accidental overwrite or delete doesn't just wipe the data

**IAM:**
- A test user with a policy that only allows `s3:GetObject` and `s3:ListBucket` — no write, no delete, scoped to this one bucket's ARN, not `*`

## How I verified it

I didn't just trust the Terraform plan — checked the actual AWS state via CLI:

```bash
aws s3api get-public-access-block --bucket <bucket-name>
aws s3api get-bucket-encryption --bucket <bucket-name>
aws s3api get-bucket-versioning --bucket <bucket-name>
aws iam list-attached-user-policies --user-name terraform-test-user
```

## One thing I noticed about references

Every security resource points back to the bucket with `aws_s3_bucket.practice_bucket.id` or `.arn` instead of a hardcoded name. That's what let Terraform figure out the create order on its own (bucket first, then its configs, then the IAM policy that needs the ARN) — and destroy everything in the reverse order without me telling it to.

## Screenshots

<img width="1680" height="365" alt="terraform_init_hardening" src="https://github.com/user-attachments/assets/733c9c89-4282-455e-ae76-4abe1e3cc29b" />
<img width="1680" height="1050" alt="terraform_plan_1" src="https://github.com/user-attachments/assets/8daa32e6-0006-47a7-8f84-926212e1a249" />
<img width="1680" height="1050" alt="terraform_plan_2" src="https://github.com/user-attachments/assets/602fd592-f78f-4abe-8909-1e1e1e0b9bd9" />
<img width="1680" height="1050" alt="terraform_apply_1" src="https://github.com/user-attachments/assets/5a1cc40b-c03f-4795-962c-9dbb881d65d0" />
<img width="1680" height="1050" alt="terraform_apply_2" src="https://github.com/user-attachments/assets/696e586c-bd86-4c03-bc66-671767110f2d" />
<img width="1680" height="154" alt="public_access_block" src="https://github.com/user-attachments/assets/2ff4e30d-1d0f-4675-8a1f-b24605a3ced0" />
<img width="1676" height="287" alt="encryption_bucket" src="https://github.com/user-attachments/assets/162be3d6-22d4-46c7-92a4-1c12fe8cc21f" />
<img width="1680" height="84" alt="versioning_bucket" src="https://github.com/user-attachments/assets/90970034-ebc0-4f43-9415-39426feef8f3" />
<img width="1680" height="157" alt="attachment_policy" src="https://github.com/user-attachments/assets/86ac3520-337d-4255-a180-a01f0a5766dd" />
<img width="1680" height="1050" alt="terraform_destroy_1" src="https://github.com/user-attachments/assets/70c06ef2-307a-44ed-be8c-b383066d5ec9" />
<img width="1680" height="1050" alt="terraform_destroy_2" src="https://github.com/user-attachments/assets/713350aa-cbfc-47ad-8f87-4f52db494907" />
<img width="1680" height="1050" alt="terraform_destroy_3" src="https://github.com/user-attachments/assets/5c933a94-53ce-4ed5-ab99-831842167b77" />
<img width="1680" height="61" alt="s3_destroyed_confirmed" src="https://github.com/user-attachments/assets/4b47344d-84ee-4646-adc9-e212adfe0671" />



