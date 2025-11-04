variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project_name" {
  type    = string
  default = "app-runner-demo"
}

variable "ecr_repository_name" {
  type    = string
  default = "app-repo"
}

variable "image_uri" {
  description = "Docker image URI (ECR) to deploy"
  type        = string
  default     = ""
}

variable "image_tag" {
  description = "Docker image tag to deploy from ECR"
  type        = string
  default     = "latest"
}

variable "app_version" {
  description = "Application version label"
  type        = string
  default     = "v1"
}

# Auto-scaling params for App Runner
variable "apprunner_min_size" {
  type    = number
  default = 1
}
variable "apprunner_max_size" {
  type    = number
  default = 5
}

#Github Variables
variable "account_id" {
  type    = string
  default = "526703406914"
}