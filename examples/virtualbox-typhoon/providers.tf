

terraform {
  required_providers {
    matchbox = {
      source = "poseidon/matchbox"
      version = "0.4.1"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.6.1"
    }
  }
}

provider "ct" {}

provider "matchbox" {
  endpoint    = "befruchter.home.el:8081"
  client_cert = file("~/.matchbox/tls/client.crt")
  client_key  = file("~/.matchbox/tls/client.key")
  ca          = file("~/.matchbox/tls/ca.crt")
}