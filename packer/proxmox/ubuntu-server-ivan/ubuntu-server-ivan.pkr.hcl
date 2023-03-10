# Ubuntu Server Ivan Version
# Check version descriptions in Readme

#----------
# Packer Template to create Ubuntu Server (ivan) on Proxmox 7.3

# Block with var's (there are creds)
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

# Block with VM Template
source "proxmox" "ubuntu-server-ivan" {

    # Connect to proxmox
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    password = "${var.proxmox_api_token_secret}"
    # Skip TLS
    insecure_skip_tls_verify = true

    # VM Main setting
    node = "pvehome"
    vm_name = "ubuntu-server-ivan"
    vm_id = "901"
    template_description = "Ubuntu Server: Version IVAN"

    # Setting for OS VM
    iso_file = "local:iso/ubuntu-20.04.2-live-server-amd64.iso"
    iso_storage_pool = "local"
    unmount_iso = true
    qemu_agent = true
    os = "l26"

    # CPU VM
    cores = "1"

    # Memory VM
    memory = "2048"

    # Hard Disk(s) VM
    scsi_controller = "virtio-scsi-pci"
    disks {
      disk_size = "30G"
      format = "qcow2"
      storage_pool = "local-zfs"
      storage_pool_type = "zfs"
      type = "virtio"
    }

    # Network settings
    network_adapters {
      model = "virtio"
      bridge = "vmbr0"
      firewall = "false"
    }



}