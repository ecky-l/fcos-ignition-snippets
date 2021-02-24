

terraform {
  required_providers {
    matchbox = {
      source = "poseidon/matchbox"
      version = "0.4.1"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.8.0"
    }
  }
}

provider "ct" {}

provider "matchbox" {
  endpoint    = "befruchter.home.el:8081"
  client_cert = file("~/.matchbox/befruchter.home.el/client.crt")
  client_key  = file("~/.matchbox/befruchter.home.el/client.key")
  ca          = file("~/.matchbox/befruchter.home.el/ca.crt")
}