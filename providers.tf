provider "kind" {
  # Configuration options
}

provider "github" {
  owner = "uempfel"
  token = var.github_pat
}
