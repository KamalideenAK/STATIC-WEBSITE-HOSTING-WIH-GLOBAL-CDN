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
