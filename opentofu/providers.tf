terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true  # nodig zolang Proxmox een zelfondertekend certificaat gebruikt (zie document 1)

  ssh {
    agent       = false
    username    = "root"
    private_key = file("/root/.ssh/id_ed25519")
  }
}
