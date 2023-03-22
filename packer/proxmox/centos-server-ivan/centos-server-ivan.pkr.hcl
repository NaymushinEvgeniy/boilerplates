# Centos 8 Minimal Ivan Version
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
source "proxmox" "centos-server-ivan" {

    # Connect to proxmox
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # Skip TLS
    insecure_skip_tls_verify = true

    # VM Main setting
    node = "pvehome"
    vm_name = "centos-server-ivan"
    vm_id = "902"
    template_description = "Centos 8 Minimal: Version IVAN"

    # Setting for OS VM
    iso_file = "local:iso/CentOS-Stream-8-x86_64-latest-boot.iso"
    iso_storage_pool = "local"
    #iso_url = "https://mirror.yandex.ru/centos/8-stream/isos/x86_64/CentOS-Stream-8-20230308.3-x86_64-boot.iso"
    #iso_checksum = "fa0a3cdc47baa25fa2d26492e6c2abca83f1885972432f7edda27f78dc7d1573"
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
      disk_size = "40G"
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
    ssh_timeout = "10m"
    
    # Block with boot commands
    boot_command = [
        "<tab><bs><bs><bs><bs><bs>inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/user-data<enter><wait>"
      ]
    boot_wait = "5s"

    # Packer Setting for autoinstall
    http_directory = "http"
}

build {
  sources = ["source.proxmox.centos-server-ivan"]
}