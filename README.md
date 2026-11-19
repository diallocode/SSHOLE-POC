# SSHOLE-POC
Minimal reproduction environment for CVE-2026-123158 (“*sshole”), an OpenSSH authentication bypass affecting musl-based Linux systems (Alpine Linux, OpenWrt, Buildroot, Yocto).


# Repro Lab — Vagrant → Ansible → Docker

Scaffolding for an isolated reproduction environment, provisioned from code.

## 01Request flow

On the host, `vagrant up` builds a VM from the Vagrantfile, which runs an Ansible playbook inside the VM to install Docker and stage the build context. Docker then builds and runs the container on the VM's internal network only — nothing is forwarded back out to the host.
