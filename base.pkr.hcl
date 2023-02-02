packer {
  required_plugins {
    linode = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/linode"
    }
  }
}

variable "linode_token" {
  type      = string
  sensitive = true
  default   = "${env("LINODE_TOKEN")}"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "linode" "base" {
  image                     = "linode/ubuntu22.04"
  image_description         = "base ubuntu22.04 image built using Packer"
  image_label               = "base-ubuntu22.04-${local.timestamp}"
  instance_label            = "temporary-linode-${local.timestamp}"
  instance_type             = "g6-nanode-1"
  instance_tags             = ["packer"]
  linode_token              = var.linode_token
  region                    = "ap-southeast"
  ssh_username              = "root"
  ssh_clear_authorized_keys = true
  swap_size                 = 512
}

build {
  sources = ["source.linode.base"]

  # we use cloud-init to regenerate ssh host keys on VM instantiation
  provisioner "file" {
    source      = "${path.root}/base/99-overrides.cfg"
    destination = "/etc/cloud/cloud.cfg.d/99-overrides.cfg"
  }

  ## based on https://systemd.io/BUILDING_IMAGES/
  provisioner "shell" {
    inline = [
      "truncate -s0 /etc/machine-id",
      "rm /var/lib/systemd/random-seed",
      "cloud-init clean --logs --seed"
    ]
  }

}