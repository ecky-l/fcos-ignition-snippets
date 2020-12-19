
data "ct_config" "user_snippets" {
  for_each = var.user_authorized_keys
  content = templatefile("${path.module}/templates/user.yaml", {
    ssh_authorized_keys = each.value
  })
  strict = true
}

data "ct_config" "network_snippets" {
  for_each = var.networks
  content = templatefile("${path.module}/templates/net-config.yaml", {
    net_config = each.value
  })
  strict = true
}

data "ct_config" "storage_snippets" {
  for_each = var.root_partition_size_gib
  content = templatefile("${path.module}/templates/storage.yaml", {
    root_partition_size_gib = each.value
  })
}

output "user_snippets" {
  value = data.ct_config.user_snippets
}

output "network_snippets" {
  value = data.ct_config.network_snippets
}

output "storage_snippets" {
  value = data.ct_config.storage_snippets
}