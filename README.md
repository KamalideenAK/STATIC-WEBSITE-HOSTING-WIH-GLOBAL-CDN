# Static-Website-Hosting-with-Global-CDN
Deploy a secure, production‑ready static site on Amazon S3 with global delivery via Amazon CloudFront. Includes TLS with AWS Certificate Manager, IAM/S3 access controls, and reproducible IaC using Terraform. Ideal for marketing, media, or educational sites.

# Static Website Hosting with Global CDN

**Project name:** Static Website Hosting with Global CDN

**Industry:** Marketing / Media / Education

**Overview**

Host a secure, production-ready static website (company site / portfolio) on **Amazon S3** and deliver it globally with **Amazon CloudFront**. The project demonstrates secure static hosting, TLS via **AWS Certificate Manager (ACM)**, access control via **IAM** and **S3 bucket policies**, and reproducible Infrastructure-as-Code using **Terraform**. Ideal for marketing teams, media portfolios, or educational project pages.

---

## Problem statement

Many organizations need a low-cost, globally-distributed static website with strong security and an easy deployment story. The requirements are:

* Serve HTML/CSS/JS and media quickly to users worldwide.
* Ensure HTTPS everywhere with managed certificates.
* Keep origin storage private so only CDN can read objects.
* Reproducible infrastructure provisioning and CI/CD for deployers.
* Low monthly operational cost and clear cost visibility.

This repo provides a reference implementation — secure by default, production-ready caching, and a small CI pipeline to publish site updates and purge CDN cache.

---

## Architecture (high-level)

<img width="930" height="464" alt="image" src="https://github.com/user-attachments/assets/883276dc-3176-475f-b487-55e683a1d4a9" />

**Notes:**

* The ACM certificate for CloudFront **must** be requested in `us-east-1` (N. Virginia). The Terraform example uses a provider alias for that region.
* The S3 bucket is private. CloudFront uses an Origin Access Identity (OAI) to fetch objects.

---

## What this repo contains

* `README.md` (this document)
* `terraform/` — Terraform project to provision S3, CloudFront, ACM (DNS validation with Route53 optional), IAM deployer policy, and sample objects.

  * `main.tf`, `variables.tf`, `outputs.tf`
* `site/` — example static site (index.html, assets)
* `.github/workflows/deploy.yml` — GitHub Actions CI to sync files to S3 and invalidate CloudFront cache
* `samples/` — sample IAM policy, sample bucket policy, sample curl/validation scripts
* `COST_ESTIMATE.md` — short monthly cost scenarios and calculation assumptions

---

## Quick architecture summary

1. S3 (private) stores the static site (index.html, assets, images). Bucket public access is blocked.
2. CloudFront Distribution in front of the bucket provides HTTPS, caching, compression, and geo-optimized delivery.
3. ACM (in `us-east-1`) issues the TLS certificate used by CloudFront.
4. Route53 (optional) maps `www.example.com` to the CloudFront distribution via alias record.
5. GitHub Actions (or other CI) performs `aws s3 sync` and issues a CloudFront invalidation on deploy.

---

## Reproducible Infrastructure (Terraform) — Example

> Files shown are condensed for readability. Full files are available in `terraform/`.

### `terraform/variables.tf`

```hcl
variable "region" {
  description = "Primary AWS region for S3 and resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Global-unique S3 bucket name for the site"
  type        = string
}

variable "domain_name" {
  description = "Optional custom domain name (eg www.example.com)"
  type        = string
  default     = ""
}

variable "create_route53_records" {
  type    = bool
  default = false
}
```

### `terraform/main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# provider alias for us-east-1 because CloudFront/ACM cert must be in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Origin Access Identity (classic OAI) to keep the bucket private
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for static site bucket"
}

# Bucket policy to allow CloudFront OAI to GetObject
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipalReadOnly",
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        },
        Action = ["s3:GetObject"],
        Resource = ["${aws_s3_bucket.site.arn}/*"]
      }
    ]
  })
}

# Request ACM certificate in us-east-1 (for CloudFront)
resource "aws_acm_certificate" "cert" {
  provider = aws.us_east_1
  domain_name = var.domain_name
  validation_method = var.create_route53_records ? "DNS" : "EMAIL"
  lifecycle {
    create_before_destroy = true
  }
}

# OPTIONAL: If Route53 is the DNS provider in your account, create DNS validation records
# (This block assumes the domain is hosted in Route53 in the same account)
resource "aws_route53_record" "cert_validation" {
  count = var.create_route53_records && var.domain_name != "" ? length(aws_acm_certificate.cert.domain_validation_options) : 0
  name    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_name
  zone_id = data.aws_route53_zone.selected.zone_id
  type    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_type
  records = [aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_value]
  ttl     = 600
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.us_east_1
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = var.create_route53_records ? [for r in aws_route53_record.cert_validation : r.fqdn] : []
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.site.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.domain_name != "" ? [var.domain_name] : []

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.site.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
    compress     = true
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "static-site-cdn"
  }
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_bucket" {
  value = aws_s3_bucket.site.bucket
}
```

### `terraform/outputs.tf`

```hcl
output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.site.bucket
}
```

---

## Sample `site/` (example static files)

```
site/
  index.html
  404.html
  css/style.css
  images/logo.png
```

A tiny sample `index.html` is included in the repo — it helps validate the distribution. The Terraform includes `aws_s3_bucket_object` examples to upload these files, but for real sites you will likely use `aws s3 sync` from a CI job.

---

## IAM — minimal deployer policy (sample)

Use a dedicated CI IAM user or role with a policy scoped to these actions (principle of least privilege):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3Deploy",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    },
    {
      "Sid": "CloudFrontInvalidate",
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Resource": "*"
    }
  ]
}
```

**Note:** CloudFront invalidation requires the distribution ID; the policy permits any distribution for simplicity in many CI setups — narrow it if possible.

---

## CI/CD — GitHub Actions deploy example

Place this at `.github/workflows/deploy.yml`:

```yaml
name: Deploy Static Site
on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-region: us-east-1
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }} # or use access key / secret
          role-session-name: github-actions
      - name: Sync site to S3
        run: |
          aws s3 sync site/ s3://${{ secrets.S3_BUCKET }} --delete
      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation --distribution-id ${{ secrets.CLOUDFRONT_ID }} --paths "/*"
```

---

## Testing & validation

1. After provisioning, note `cloudfront_domain` output (e.g. `d1234abcdef.cloudfront.net`).
2. If you configured DNS, wait for DNS to propagate.
3. Use curl to test:

```bash
curl -I https://d1234abcdef.cloudfront.net/
# expect HTTP/2 200 and TLS details
```

4. Test cache headers:

```bash
curl -I https://d1234abcdef.cloudfront.net/index.html
# Check `x-cache` header: Hit or Miss
```

5. Perform an invalidation to purge cache after updates:

```bash
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
```

---

## Demo screenshots / short video (how to create)

I cannot create screenshots from your environment here, but you can create a short demo locally or in CI:

### Quick screenshot using `curl` + `webkit2png` or `puppeteer`

* `npm install -g puppeteer`
* `node -e "(async()=>{const p=require('puppeteer');const b=await p.launch();const page=await b.newPage();await page.goto('https://d1234abcdef.cloudfront.net');await page.screenshot({path:'demo.png',fullPage:true});await b.close();})()"`

### Make a 10s demo video from screenshots with `ffmpeg`

```bash
# create a series of screenshots (demo-001.png..demo-100.png) and then:
ffmpeg -framerate 10 -i demo-%03d.png -c:v libx264 -pix_fmt yuv420p demo.mp4
```

### Or record a browser session with OBS Studio (GUI) or `ffmpeg` screen capture for headless servers.

---

## Cost estimation (example scenarios)

> **Assumptions:** US region pricing. Prices change frequently — see AWS pricing pages for latest numbers.

**Small site example (monthly):**

* Storage: 10 GB in S3 Standard -> \~10 \* \$0.023 = **\$0.23 / month**
* Traffic: 100,000 pageviews, avg page size 1 MB → \~100 GB egress through CloudFront → 100 \* \$0.085 = **\$8.50 / month**
* Requests: CloudFront first 10M HTTP(S) requests are in many accounts free; S3 GET request costs are negligible at this scale.

**Rough total:** **\~\$10 / month** (excluding domain registration and Route53 hosted zone costs)

**Notes & levers to reduce cost:**

* Good cache TTLs and high CloudFront cache hit ratio reduce origin costs (S3 request & data transfer).
* Use optimized images, compressed assets, and Brotli/gzip to cut bytes transferred.
* Route large downloads through CloudFront and enable compression and caching policies.

---

## Security considerations

* Keep S3 bucket **private** and use OAI to ensure only CloudFront can read objects.
* Block public ACLs via `aws_s3_bucket_public_access_block`.
* Use HTTPS (ACM certificate) and enforce TLSv1.2 minimum.
* Use IAM roles for CI rather than long-lived access keys.
* Turn on CloudTrail and CloudWatch billing alarms for cost control.

---

## Next steps & enhancements

* Add **Origin Shield** to reduce origin load for dynamic backends.
* Use **Lambda\@Edge** or **CloudFront Functions** for edge transforms (e.g. A/B testing, cookies, redirects).
* Add **image optimization** on the fly (e.g., using Lambda\@Edge with sharp or third-party services).
* Integrate with a real CI/CD pipeline (GitHub, GitLab, Bitbucket) and store artifacts.

---

## Files you can find in this repo

* `/terraform` — IaC for core infra
* `/site` — sample site
* `/.github/workflows/deploy.yml` — deploy pipeline
* `/samples` — IAM policies, bucket policy, validation scripts

---

## License

MIT — feel free to reuse and adapt this for your organization.

---
