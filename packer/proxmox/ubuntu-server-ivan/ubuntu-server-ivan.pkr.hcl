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
  sensitive = true
}

# Block with VM Template
source "proxmox" "ubuntu-server-ivan" {

    # Connect to proxmox
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # Skip TLS
    insecure_skip_tls_verify = true

    # VM Main setting
    node = "pvehome"
    vm_name = "ubuntu-server-ivan"
    vm_id = "901"
    template_description = "Ubuntu Server: Version IVAN"

    # Setting for OS VM
    iso_file = "local:iso/ubuntu-22.04.2-live-server-amd64.iso"
    iso_storage_pool = "local"
    unmount_iso = true
    qemu_agent = true
    os = "l26"

    # CPU VM
    cores = "2"

    # Memory VM
    memory = "2048"

    # Hard Disk(s) VM
    scsi_controller = "virtio-scsi-pci"
    disks {
      disk_size = "30G"
      format = "raw"
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

    # Cloud-init config
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # SSH settings
    ssh_username = "sadmin.ney"
    
    # Block with boot commands
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
        "<F10><wait>"
      ]
    boot_wait = "5s"

    # Packer Setting for autoinstall
    http_directory = "http"
}

build {
  sources = ["source.proxmox.ubuntu-server-ivan"]
}