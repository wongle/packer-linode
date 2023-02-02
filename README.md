# packer-linode
Packer templates to build image artifacts for Linode

This uses `cloud-init` to help with regenerating ssh host keys when a new VM is instantiated from this image artifact.  Since we're already there, we can do some VM setup basics like setting a default timezone and update/upgrade packages.

Linode Personal Access Token can be loaded via environment variable `LINODE_TOKEN`.

Environment variable secrets can be loaded via 1Password CLI using the `.env` file:
```shell
op run --env-file=".env" -- packer build
```
