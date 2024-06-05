variable "environment" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}

variable "domain_name" {
  description = "The domain name to use for the CloudFront distribution"
  type        = string
  default     = "scoreboard.bpritchard.dev"
}
