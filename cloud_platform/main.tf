resource "proxmox_vm_qemu" "cloudinit-test" {
  count = 2
  vmid  = "40${count.index}"
  name  = "k3s-m40${count.index}.${var.domain}"

  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = "zeus"

  # The destination resource pool for the new VM
  pool = "dev"

  # The template name to clone this vm from
  clone      = "ubuntu-server-24-04"
  full_clone = true

  # Activate QEMU agent for this VM
  agent = 1

  os_type = "cloud-init"

  cores   = 2
  sockets = 1
  cpu     = "kvm64" # if empty 'host' is default
  memory  = 2048
  balloon = 1024

  scsihw  = "virtio-scsi-pci" # "lsi"

  # Setup the disk
  boot = "order=virtio0"
  disks {
    ide {
      ide2 {
        cloudinit {
          storage  = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size     = 32
          cache    = "writeback"
          storage  = "local-lvm"
          iothread = true
          discard  = true
        }
      }
    }
  } # end setup Disks

  # Setup the network interface and assign a mac address
  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = var.master_address[count.index]
  }

  # Setup the ip address using cloud-init.
  # Keep in mind to use the CIDR notation for the ip.
  # ipconfig0 = "ip=192.168.8.114/24,gw=192.168.8.1"
  ipconfig0 = "ip=dhcp"

  # Setup cloud init data
  ciuser     = var.cloud_init_username
  cipassword = var.cloud_init_password
  sshkeys    = var.cloud_init_sshkeys

}
