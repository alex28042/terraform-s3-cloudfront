# 🪣 S3 + 🌐 CloudFront CDN — Terraform Deploy

One-command deploy of a **secure S3 bucket + CloudFront CDN** on AWS. Designed for serving cached assets (images, PDFs, videos) to a frontend application with maximum speed and minimum cost.

Built with Terraform modules following **Clean Code** and **SOLID** principles.

## Use case

You have a web app (e.g. a marketplace) and need:
- A **private S3 bucket** where your backend uploads files (images, documents, etc.)
- A **CloudFront CDN** so your frontend loads those assets as fast as possible, cached globally
- **Security hardened** out of the box — no public access to S3, HTTPS enforced, security headers

## Quick start

```bash
git clone https://github.com/alex28042/deploy-s3-and-cdn.git
cd deploy-s3-and-cdn
chmod +x deploy.sh
./deploy.sh
```

The interactive script will guide you through:

1. **AWS credentials** — Access Key, AWS Profile, or SSO
2. **Project config** — name, environment, region, cache TTL, versioning
3. **Summary** — review before deploying
4. **Deploy** — `terraform init` + `plan` + `apply` automatically

## Requirements

| Tool | Required | Install |
|------|----------|---------|
| [Terraform](https://terraform.io) >= 1.5 | Yes | `brew install terraform` |
| [AWS CLI](https://aws.amazon.com/cli/) | Recommended | `brew install awscli` |
| AWS account with IAM credentials | Yes | — |

## Architecture

```
┌──────────────┐       ┌─────────────────────┐       ┌──────────────┐
│              │       │                     │       │              │
│   Frontend   │──────▸│  CloudFront (CDN)   │──────▸│   S3 Bucket  │
│              │ HTTPS │                     │  OAC  │  (private)   │
└──────────────┘       └─────────────────────┘       └──────┬───────┘
                                                            │
                                                     ┌──────┴───────┐
                                                     │              │
                                                     │   Backend    │
                                                     │  (upload/    │
                                                     │   read/      │
                                                     │   delete)    │
                                                     └──────────────┘
```

- **Frontend** reads images via CDN URL → blazing fast, cached at edge
- **Backend** writes/reads files directly to S3 via IAM policy
- **No one** can access S3 directly — only through CloudFront (OAC) or the backend (IAM)

## Project structure

```
deploy-s3-and-cdn/
├── deploy.sh                     # Interactive entry point
├── scripts/                      # Modular bash scripts (SOLID)
│   ├── utils.sh                  # Colors, prompts, helpers
│   ├── check_dependencies.sh     # Verify terraform + aws cli
│   ├── configure_aws.sh          # AWS credential setup
│   ├── configure_project.sh      # Project variables + region
│   ├── show_summary.sh           # Pre-deploy review
│   ├── run_terraform.sh          # Init, plan, apply
│   └── destroy.sh                # Teardown with double confirmation
├── main.tf                       # Root orchestrator (modules)
├── locals.tf                     # Computed names
├── variables.tf                  # Input variables
├── outputs.tf                    # Output values
├── terraform.tfvars.example      # Config template
└── modules/
    ├── s3/                       # Storage module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── cdn/                      # Distribution module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── iam/                      # Permissions module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Configuration

### Via interactive script (recommended)

```bash
./deploy.sh
```

### Via terraform.tfvars (manual)

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init && terraform apply
```

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Project name used as prefix for all resources | — (required) |
| `environment` | `dev`, `staging`, or `prod` | `prod` |
| `aws_region` | AWS region to deploy in | `eu-west-1` |
| `cache_ttl` | CloudFront cache TTL in seconds | `604800` (7 days) |
| `price_class` | CDN coverage: `PriceClass_100`, `PriceClass_200`, `PriceClass_All` | `PriceClass_100` |
| `enable_versioning` | Enable S3 versioning (doubles storage) | `false` |
| `create_iam_user` | Create IAM user with Access Keys for Railway/Vercel/Render | `false` |
| `cors_allowed_origins` | CORS allowed origins | `["*"]` |
| `tags` | Additional tags for all resources | `{}` |

### Available regions

The deploy script offers 14 regions including full European coverage:

| Code | Location |
|------|----------|
| `eu-west-1` | Ireland |
| `eu-west-2` | London |
| `eu-west-3` | Paris |
| `eu-central-1` | Frankfurt |
| `eu-central-2` | Zurich |
| `eu-south-1` | Milan |
| `eu-south-2` | Spain |
| `eu-north-1` | Stockholm |
| `us-east-1` | N. Virginia |
| `us-west-2` | Oregon |
| `sa-east-1` | Sao Paulo |
| `ap-southeast-1` | Singapore |
| `ap-northeast-1` | Tokyo |
| Custom | Any valid AWS region |

## Security

| Feature | Implementation |
|---------|---------------|
| S3 public access | Blocked (all 4 flags) |
| S3 encryption | AES-256 (SSE-S3, free) |
| S3 transport | HTTPS enforced via bucket policy |
| CloudFront → S3 | Origin Access Control (OAC) |
| HTTPS | Redirect HTTP → HTTPS |
| TLS | Minimum TLS 1.2 |
| HTTP protocol | HTTP/2 + HTTP/3 |
| X-Content-Type-Options | nosniff |
| X-Frame-Options | DENY |
| Strict-Transport-Security | max-age=31536000; includeSubDomains; preload |
| Referrer-Policy | strict-origin-when-cross-origin |
| Content-Security-Policy | default-src 'none'; img-src 'self' |
| Backend access | Least-privilege IAM policy (Put, Get, Delete, List) |

## Cost optimization (Free Tier friendly)

| Resource | Free Tier allowance | How we optimize |
|----------|-------------------|-----------------|
| S3 storage | 5GB/month (12 months) | Versioning off by default |
| S3 requests | 20K GET, 2K PUT/month | 7-day cache TTL reduces GETs |
| S3 encryption | SSE-S3 = free | AES256, not KMS ($1/key/month) |
| CloudFront | 1TB transfer + 10M requests/month (always free) | PriceClass_100 + Brotli/Gzip compression |

## Outputs

After deployment, you get:

| Output | Description |
|--------|-------------|
| `cdn_url` | CDN URL for frontend (`https://d1234.cloudfront.net`) |
| `cdn_distribution_id` | Distribution ID for cache invalidation |
| `s3_bucket_name` | Bucket name for backend configuration |
| `s3_bucket_arn` | Bucket ARN |
| `backend_policy_arn` | IAM policy ARN to attach to backend role |
| `backend_access_key_id` | Access Key ID (only if `create_iam_user = true`) |
| `backend_secret_access_key` | Secret Access Key (only if `create_iam_user = true`) |

## Connect your backend (Railway, Vercel, Render, etc.)

If you set `create_iam_user = true`, Terraform creates an IAM user with Access Keys and shows them after deployment. Add these as **environment variables** in your platform:

| Env Variable | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | From terraform output |
| `AWS_SECRET_ACCESS_KEY` | From terraform output |
| `AWS_REGION` | The region you selected (e.g. `eu-west-1`) |
| `S3_BUCKET_NAME` | From terraform output |
| `CDN_URL` | From terraform output |

Then use the AWS SDK in your backend to upload/read/delete files:

**Node.js (NestJS, Express, etc.)**
```typescript
import { S3Client, PutObjectCommand, GetObjectCommand, DeleteObjectCommand } from "@aws-sdk/client-s3";

const s3 = new S3Client({ region: process.env.AWS_REGION });

// Upload
await s3.send(new PutObjectCommand({
  Bucket: process.env.S3_BUCKET_NAME,
  Key: "boats/yacht-001.webp",
  Body: fileBuffer,
  ContentType: "image/webp",
}));

// The image is now available at: ${CDN_URL}/boats/yacht-001.webp
```

**Python (Django, FastAPI, etc.)**
```python
import boto3

s3 = boto3.client("s3", region_name=os.environ["AWS_REGION"])

# Upload
s3.upload_fileobj(file, os.environ["S3_BUCKET_NAME"], "boats/yacht-001.webp")

# The image is now available at: {CDN_URL}/boats/yacht-001.webp
```

**Java (Spring Boot)**
```java
S3Client s3 = S3Client.builder()
    .region(Region.of(System.getenv("AWS_REGION")))
    .build();

s3.putObject(
    PutObjectRequest.builder()
        .bucket(System.getenv("S3_BUCKET_NAME"))
        .key("boats/yacht-001.webp")
        .contentType("image/webp")
        .build(),
    RequestBody.fromBytes(fileBytes)
);
```

> **Note:** If you need the secret key again later, run: `terraform output -raw backend_secret_access_key`

## Usage after deployment

**Frontend** — load cached assets:
```html
<img src="https://d1234abcd.cloudfront.net/boats/yacht-001.webp" />
```

**Backend** — upload files:
```bash
aws s3 cp image.webp s3://my-project-prod-assets/boats/image.webp
```

**Invalidate cache** — after updating an image:
```bash
aws cloudfront create-invalidation \
  --distribution-id EXXXXXXXXXXXXX \
  --paths "/boats/*"
```

## Destroy

```bash
./deploy.sh --destroy
```

Double confirmation required. This removes all AWS resources created by Terraform.

## License

MIT
