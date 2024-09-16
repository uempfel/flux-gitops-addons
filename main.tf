locals {
  kind_clusters_dir = "../kind-clusters"
  kind_clusters = {
    for f in fileset(local.kind_clusters_dir, "**/*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${local.kind_clusters_dir}/${f}"))
  }
}

module "kind_clusters" {
  for_each          = local.kind_clusters
  source            = "./modules/kind"
  github_repository = "addon-user"
  github_token      = var.github_pat
  name              = each.key
  config            = each.value
}

