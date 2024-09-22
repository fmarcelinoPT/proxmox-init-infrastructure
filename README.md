# Proxmox Init Infrastructure

This scripts will provision the following infrastructure for `my-homelab`:

1. VM for Pi-Hole
1. VM's for OpenShift

## Preparation

Resources: [telmate/proxmox](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-proxmox-user-and-role-for-terraform)

1. Create user `automation` **WITH NO PASSWORD**

1. Create role:

    ```bash
    pveum role add terraform-provider -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
    ```

1. Add role to user `automation`

    ```bash
    pveum aclmod / -user automation@pam -role terraform-provider
    ```

1. Create API token with:

    - `User` = `automation`
    - `Token Id` = `rfbot`
    - `Privilege Separation` = `false`

1. Take note of the Secret and up `terraform.tfvars` accordingly:

```ini
pve_url          = "<PVE API ENDPOINT>"             # i.e. https://hera.onemarc.io:8006/api2/json
pve_tls_insecure = true
pve_token_id     = "<TOKEN ID>"                     # i.e. automation@pam!tfbot
pve_token_secret = "<TOKEN SECRET>"                 # i.e. 2f4a7382-d340-4420-9caf-dc9b2827f5c6

domain = "<TARGET DOMAIN>"                          # i.e. onemarc.io

cloud_init_username = "<SO USERNAME>"               # i.e. my_support
cloud_init_password = "<SO PASSWORD>"               # i.e. my_password
cloud_init_sshkeys  = "<SSH KEY PUB CONTENT>"       # i.e. ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCPZ3QsQoio+7wY215SeTxZDkJDMHdx6i9Z+OXoNgqxdAB1aBmYsPwfNVHXxvcsuan6AhmxHmW8Asmv4sdqgBEit9pQ0EsYwXPlrkt84VOY+8yIJAftqIgqcOh+fewOKpWvWtkoEHpY5uWzp+8RCaf6tSDjEgJ8GDbTa3Wm5yg3YtXgiouAutpsTz4jdeqeRl8iKsA3HximBvKv+ELBofbS2Um/xqeIiBjizOTQC4sjI40JXE8TvHNHeLQpkwzTGAcmwpW9dEtnunQH34i8jlXpnhNco9P/atpAZiA8QofOiw1bK7TzCeOh7KbMfCmKurUptgQ1EUaF6i8tJdJvfrnl

master_address = [
  # List of mac address for MASTER nodes
  # i.e
  # "7A:61:BE:ED:48:D9",
  # "16:DB:E5:F0:D6:C0"
]

worker_address = [
  # List of mac address for WORKER nodes
  # i.e
  # "7A:61:BE:ED:48:D9",
  # "16:DB:E5:F0:D6:C0"
]
```
