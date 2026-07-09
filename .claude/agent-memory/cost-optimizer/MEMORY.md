# Cost Optimizer Memory - Portfolio Site (ap-south-1)

## Key Findings (2026-07-09)

### Primary Optimizations
1. **CloudFront Price Class** (HIGH impact)
   - Current: PriceClass_200 (199 edge locations, ~$150-300/mo extra)
   - Target: PriceClass_100 (100 cheapest locations, covers India well)
   - File: `terraform/main.tf:78`

2. **S3 Versioning Lifecycle** (MEDIUM impact)
   - Issue: Versioning enabled with no cleanup → storage bloat
   - Solution: Add lifecycle rule to expire old versions after 7 days
   - Saves: $20-50/mo (depends on deploy frequency)
   - File: Add after `terraform/main.tf:30`

3. **S3 Intelligent-Tiering** (LOW impact, optional)
   - Saves: $5-15/mo for infrequent access patterns
   - Add as optional enhancement, not critical

## Architecture Context
- Static portfolio site (India-based, default region ap-south-1)
- S3 + CloudFront + GitHub Actions deployment
- Versioning enabled (good for safety, bad for cost without lifecycle)
- No custom domain configured yet

## Deployment Patterns
- Deploys trigger via GitHub Actions on main push
- CloudFront invalidation already in place
- No filename versioning in use (standard cache behavior)
