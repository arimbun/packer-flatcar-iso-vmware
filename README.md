# Flatcar Container Linux - ISO Build

Flatcar Container Linux build from ISO using [Packer](https://www.packer.io/).
## Prerequisites

- Packer 1.8+
- [VMware Workstation](https://www.vmware.com/au/products/workstation-pro.html) (on Windows) or [VMware Fusion](https://www.vmware.com/au/products/fusion.html) (on OS X).

## Usage

```sh
packer build flatcar.pkr.hcl
```

Login username is `core` and password is `core`.
