resource "proxmox_virtual_environment_vm" "k3s_server" {
  name      = "k3s-server-1"
  node_name = var.proxmox_node
  vm_id     = 200

  cpu {
    cores = 14
    type  = "host"   # geeft de VM directe toegang tot de instructieset van je i7-12700K
  }

  memory {
    dedicated = 24576   # 24 GB, zoals begroot in sectie 3 van de briefing
  }

  agent {
    enabled = true   # QEMU guest agent, geeft Proxmox inzicht in de VM (bv. het daadwerkelijke IP)
  }

  started = true

  on_boot = true   # cruciaal: laat de VM automatisch meestarten als Proxmox zelf opstart
                    # (bv. na een stroomstoring). Zonder dit blijft de VM na een herstart
                    # van de Proxmox-host uitgeschakeld totdat je hem handmatig start.

  # Schijf 1: besturingssysteem
  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    size         = 20
    discard      = "on"
    ssd          = true
  }

  # Schijf 2: data, voor /var/lib/rancher (k3s, straks gemount door Ansible in document 4b)
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi1"
    size         = 150
    discard      = "on"
    ssd          = true
  }

  scsi_hardware = "virtio-scsi-single"

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"   # Linux 2.6+ kernel (geldt ook voor moderne kernels)
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = var.vm_ip_address
        gateway = var.vm_gateway
      }
    }

    dns {
      servers = var.vm_dns_servers
    }

    user_account {
      username = "ansible"
      keys     = [var.ssh_public_key]
    }
  }

  boot_order = ["scsi0"]
}

resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  file_name    = "jammy-server-cloudimg-amd64.qcow2.img"
}
