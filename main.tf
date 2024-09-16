terraform {
  required_version = ">= 1.1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"  # Replace with the latest stable version
      # version = "2.9.14"  # Replace with the latest stable version
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://zeus.onemarc.io:8006/api2/json"
  pm_api_token_id = "root@pam!mptd"
  pm_api_token_secret = "3b46b621-afe8-4ea2-87ae-1ef8526d4af7"
  pm_tls_insecure = true
}

variable "master_address" {
  type        = list(string)
  description = "The address of the master nodes"
}

variable "worker_address" {
  type        = list(string)
  description = "The address of the worker nodes"
}

# ----------------------------------------------------------------

resource "proxmox_vm_qemu" "cloudinit-test" {
    count = 2
    vmid  = "40${count.index}"
    name  = "k3s-m40${count.index}"

    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "zeus"

    # The destination resource pool for the new VM
    pool = "dev"

    # The template name to clone this vm from
    clone        = "ubuntu-server-24-04"
    full_clone   = true

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    sockets = 1
    vcpus = 0
    cpu = "kvm64"	# if empty 'host' is default
    memory = 2048
    scsihw = "virtio-scsi-pci" # "lsi"

    # Setup the disk
    disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        virtio {
            virtio0 {
                disk {
                    size            = 32
                    cache           = "writeback"
                    # storage         = "ceph-storage-pool"
                    storage         = "local-lvm"
                    # storage_type    = "rbd"
                    iothread        = true
                    discard         = true
                }
            }
        }
    }

    # Setup the network interface and assign a vlan tag: 256
    network {
        model   = "virtio"
        bridge  = "vmbr0"
        macaddr = var.master_address[count.index]
    }

    # Setup the ip address using cloud-init.
    boot = "order=virtio0"
    # Keep in mind to use the CIDR notation for the ip.
    # ipconfig0 = "ip=192.168.8.114/24,gw=192.168.8.1"
    ipconfig0 = "ip=dhcp"

    ciuser = "ubuntu"
    cipassword = "password"

}