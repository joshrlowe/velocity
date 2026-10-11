variable "aws_account_id" {
  description = "AWS account that owns all jlowe.ai infrastructure"
  type        = string
  default     = "509399626117"
}

variable "github_repos" {
  description = "owner/name of the GitHub repos allowed to assume the CI roles"
  type        = list(string)
  default     = ["joshrlowe/velocity"]
}
