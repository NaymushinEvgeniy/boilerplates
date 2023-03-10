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