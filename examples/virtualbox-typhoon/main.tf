
locals {
    enp0s3_ipv4 = {
        "method" = "manual"
        "address1" = "10.10.0.10/16,10.10.0.1"
        "dns" = "10.10.0.1;"
        "dns-search" = "local.vlan;"
        "never-default" = "true"
    }
    enp0s8_ipv4 = {
        "method" = "manual"
        "address1" = "192.168.56.20/24"
        "never-default" = "true"
    }
    enp0s9_ipv4 = {
      "ipv4" = {
        "method" = "auto"
        "ignore-auto-dns" = "true"
      }
    }
}

module "virtualbox-snippets" {
  source = "../../modules/ignition-snippets"
  networks = {
    k1 = {
      enp0s3 = {
        ipv4 = merge(local.enp0s3_ipv4, {address1="10.10.0.10/16,10.10.0.1"})
      }
      enp0s8 = {
        ipv4 = merge(local.enp0s8_ipv4, {address1="192.168.56.20/24"})
      }
      enp0s9 = local.enp0s9_ipv4
    }
    k2 = {
      enp0s3 = {
        ipv4 = merge(local.enp0s3_ipv4, {address1="10.10.0.11/16,10.10.0.1"})
      }
      enp0s8 = {
        ipv4 = merge(local.enp0s8_ipv4, {address1="192.168.56.21/24"})
      }
      enp0s9 = local.enp0s9_ipv4
    }
  }
  root_partition_size_gib = {
    k1 = 24,
    k2 = 24
  }
}


module "vluster" {
  source = "git::https://github.com/poseidon/typhoon.git//bare-metal/fedora-coreos/kubernetes"
  cluster_name = "vluster"
  matchbox_http_endpoint = "http://10.10.0.1:8080"
  ssh_authorized_key = file("~/.ssh/id_rsa.pub")
  k8s_domain_name = "k1.local.vlan"
  os_version = "32.20201104.3.0"
  cached_install = true
  network_ip_autodetection_method = "interface=enp0s3"
  controllers = [
    {
      name   = "k1"
      mac    = "08:00:27:B7:80:3F"
      domain = "k1.local.vlan"
    }
  ]
  workers = [
    {
      name   = "k2",
      mac    = "08:00:27:37:B8:F5"
      domain = "k2.local.vlan"
    }
  ]
  snippets = {
    k1 = [
      module.virtualbox-snippets.network_snippets.k1.content,
      module.virtualbox-snippets.storage_snippets.k1.content,
    ],
    k2 = [
      module.virtualbox-snippets.network_snippets.k2.content,
      module.virtualbox-snippets.storage_snippets.k2.content,
    ],
  }
}

resource "local_file" "vluster-kubeconfig" {
  content  = module.vluster.kubeconfig-admin
  filename = "${path.cwd}/outputs/kubeconfig"
}
