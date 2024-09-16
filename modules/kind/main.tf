resource "kind_cluster" "this" {
  name           = var.name
  node_image     = var.config.cluster.node_image
  wait_for_ready = var.config.cluster.wait_for_ready

  kind_config {
    kind        = try(var.config.cluster.kind_config.kind, null)
    api_version = try(var.config.cluster.kind_config.apiVersion, null)

    dynamic "node" {
      for_each = var.config.cluster.kind_config.nodes

      content {
        role                   = try(node.value.role, null)
        kubeadm_config_patches = try(node.value.kubeadmConfigPatches, null)

        dynamic "extra_port_mappings" {
          for_each = toset(node.value.extraPortMappings)
          #iterator = "value"
          content {
            container_port = try(extra_port_mappings.value.containerPort, null)
            host_port      = try(extra_port_mappings.value.hostPort, null)
            protocol       = try(extra_port_mappings.value.protocol, null)
          }
        }
      }

    }
  }
}


resource "github_repository" "this" {
  name        = var.name
  description = var.name
  visibility  = "public"
  auto_init   = true # This is extremely important as flux_bootstrap_git will not work without a repository that has been initialised
}

# resource "flux_bootstrap_git" "this" {
#   depends_on = [github_repository.this]

#   embedded_manifests = true
#   path               = "clusters/${var.name}"
# }

resource "null_resource" "flux_bootstrap" {

  provisioner "local-exec" {
    environment = {
      "GITHUB_TOKEN" = var.github_token
    }
    when        = create
    quiet       = true
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
    flux bootstrap github --owner=${var.github_org} --repository=${var.name} --private=false --personal=true --path=clusters/${var.name}
    EOF
  }
  depends_on = [kind_cluster.this, github_repository.this]
}