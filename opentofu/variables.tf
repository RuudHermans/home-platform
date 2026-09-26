variable "proxmox_endpoint" {
  description = "URL van de Proxmox API"
  type        = string
  default     = "https://192.168.2.10:8006/"
}

variable "proxmox_api_token" {
  description = "Proxmox API-token (user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Naam van de Proxmox-node"
  type        = string
  default     = "pve"
}

variable "vm_ip_address" {
  description = "Statisch IP-adres voor de k3s-VM, met CIDR-suffix"
  type        = string
  default     = "192.168.2.11/24"
}

variable "vm_gateway" {
  description = "Gateway-IP van je thuisnetwerk — dit is het IP-adres van je router, NIET een vaste waarde die voor elk netwerk hetzelfde is. Je hebt dit adres opgezocht in document 1 (sectie 'IP-planning, nu alvast'), bijvoorbeeld via `ipconfig` (Windows), `ip route` (Linux/WSL) of de inlogpagina van je router. Het onderstaande is puur een voorbeeldwaarde — vul je eigen, opgezochte adres in."
  type        = string
  default     = "192.168.2.254"
}

variable "vm_dns_servers" {
  description = "DNS-servers die de VM via cloud-init meekrijgt. Zonder deze instelling krijgt de VM geen (betrouwbare) DNS-configuratie mee, wat later kan leiden tot fouten bij het installeren van k3s of pakketten omdat domeinnamen niet opgelost kunnen worden. Standaard wordt hier dezelfde router (gateway) als DNS-server gebruikt, wat in de meeste thuisnetwerken werkt omdat de router zelf als DNS-forwarder optreedt — heeft jouw router deze functie niet, of gebruik je liever een publieke DNS-dienst, vul dan bijvoorbeeld `[\"1.1.1.1\", \"9.9.9.9\"]` in."
  type        = list(string)
  default     = ["192.168.2.254"]
}

variable "ssh_public_key" {
  description = "Publieke SSH-sleutel voor de standaardgebruiker op de VM"
  type        = string
}
