# Security Auditor Memory

## Project Context
- Static portfolio site: S3 + CloudFront + GitHub Actions OIDC
- Terraform files: `terraform/main.tf`, `variables.tf`, `providers.tf`, `outputs.tf`, `backend.tf`
- GitHub Actions workflow: `.github/workflows/deploy.yml`

## Confirmed Patterns (from audit on 2026-07-09)

### Hardcoded Secrets in Workflow Files
- AWS account IDs, IAM role ARNs, S3 bucket names, and CloudFront distribution IDs are frequently hardcoded directly into `.github/workflows/` YAML files.
- These should use GitHub Actions secrets (`${{ secrets.VAR }}`) or be moved to Terraform outputs consumed at runtime.
- See: `patterns.md` for detail.

### S3 Encryption Gap
- `aws_s3_bucket` without an `aws_s3_bucket_server_side_encryption_configuration` block defaults to SSE-S3 since AWS January 2023, but this should be explicitly declared for compliance and to allow future upgrade to SSE-KMS.

### CloudFront — No Security Headers
- CloudFront distributions without a `aws_cloudfront_response_headers_policy` resource are missing CSP, X-Frame-Options, HSTS, X-Content-Type-Options, Referrer-Policy, and Permissions-Policy headers.
- This is a consistent gap in scaffolded configs.

### CloudFront — No Access Logging
- CloudFront `logging_config` block is routinely absent; S3 bucket access logging (`aws_s3_bucket_logging`) is also absent.
- Both should be enabled for incident response and compliance.

### Backend State — Commented Out
- `backend.tf` ships with the S3/DynamoDB backend block commented out, leaving state local. This is a documented bootstrap pattern but creates risk if not activated before team use.

### IAM OIDC Role — Not Present in Terraform
- The IAM OIDC provider and `github-actions-deploy` role are referenced in the workflow but not defined in `terraform/`. The trust policy and permissions cannot be reviewed without the Terraform source that created them.

### Geo-Restriction Absent
- `geo_restriction { restriction_type = "none" }` is the default and acceptable for a public portfolio, but should be a deliberate decision and documented.

## Checklist for Every Audit
- [ ] S3 public access block (all 4 flags true)
- [ ] S3 encryption at rest (explicit SSE block)
- [ ] S3 access logging
- [ ] S3 versioning
- [ ] CloudFront viewer_protocol_policy = redirect-to-https
- [ ] CloudFront uses OAC (not OAI)
- [ ] CloudFront security response headers policy
- [ ] CloudFront access logging
- [ ] IAM: no wildcards in actions or resources
- [ ] OIDC trust policy scoped to specific repo + branch
- [ ] No hardcoded ARNs, account IDs, or bucket names in workflow YAML
- [ ] Terraform backend encrypted and remote
- [ ] Provider version pinned (not just ~>)
