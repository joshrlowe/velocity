variable "aws_account_id" {
  description = "AWS account that owns all jlowe.ai infrastructure"
  type        = string
  default     = "509399626117"
}

variable "github_repos" {
  description = <<-EOT
    GitHub repos allowed to assume the CI roles, written as the OIDC `sub`
    claim prefix that follows "repo:". This repo issues immutable subjects
    (owner@owner_id/name@repo_id); check a repo's prefix with
    `gh api repos/OWNER/NAME/actions/oidc/customization/sub`.
  EOT
  type        = list(string)
  default     = ["joshrlowe@89754639/velocity@1406039318"]
}
