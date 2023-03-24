packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "flatcar-lts-amd64" {
  vm_name                = "flatcar-lts-amd64"
  vmdk_name              = "flatcar-lts-amd64"
  guest_os_type          = "linux"
  cpus                   = 2
  memory                 = 4096
  headless               = "false"
  disk_size              = 40960
  disk_type_id           = 0
  iso_url                = "https://lts.release.flatcar-linux.net/amd64-usr/current/flatcar_production_iso_image.iso"
  iso_checksum           = "sha512:ba080a9df0430a74a4d72929f38673528a282cea428df4939d2e23355743d6ab360a3f4fc0cbb72d7c1e6a6f9a51994b50836c09bbab9d60c5e6ef2edf669d7d"
  shutdown_command       = "sudo poweroff"
  ssh_username           = "core"
  ssh_password           = "core"
  ssh_port               = 22
  ssh_timeout            = "30m"
  ssh_handshake_attempts = "300"
  boot_wait              = "45s"  # Wait long enough for shell to be opened before entering boot commands
  boot_command = [
    "sudo passwd core<enter><wait>",
    "core<enter>",
    "core<enter>",
    "sudo systemctl start sshd.service<enter>"
  ]
}

build {
  name = "flatcar-lts-amd64"
  sources = [
    "source.vmware-iso.flatcar-lts-amd64"
  ]

  provisioner "file" {
    source = "./config.yaml"
    destination = "/home/core/"
  }

  provisioner "shell" {
    inline = [
      "docker run --rm -i quay.io/coreos/butane:latest < config.yaml > ignition.json",
      "sudo flatcar-install -d /dev/sda -C stable -i ignition.json"
    ]
  }
}
