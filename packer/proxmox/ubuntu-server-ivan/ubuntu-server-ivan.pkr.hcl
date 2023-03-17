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

variable "password" {
  type = string
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
    iso_file = "local:iso/ubuntu-20.04.5-live-server-amd64.iso"
    iso_storage_pool = "local"
    #iso_url = "https://releases.ubuntu.com/20.04/ubuntu-20.04.5-live-server-amd64.iso"
    iso_checksum = "5035be37a7e9abbdc09f0d257f3e33416c1a0fb322ba860d42d74aa75c3468d4"
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
    cloud_init_storage_pool = "local"

    # SSH settings
    ssh_username = "sadmin"
    ssh_password = "${var.password}"
    ssh_private_key_file = "~/.ssh/cloud_init_rsa"
    ssh_timeout = "20m"
    
    # Block with boot commands
    boot_command = [
        "<esc><wait><esc><wait>",
        "<f6><wait><esc><wait>",
        "<bs><bs><bs><bs><bs>",
        "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
        "--- <enter>"
      ]
    boot_wait = "5s"

    # Packer Setting for autoinstall
    http_directory = "http"
}

build {
  sources = ["source.proxmox.ubuntu-server-ivan"]
}