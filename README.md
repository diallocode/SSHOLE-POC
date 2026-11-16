# SSHOLE-POC
Minimal reproduction environment for CVE-2026-123158 (“*sshole”), an OpenSSH authentication bypass affecting musl-based Linux systems (Alpine Linux, OpenWrt, Buildroot, Yocto).


# Repro Lab — Vagrant → Ansible → Docker

Scaffolding for an isolated reproduction environment, provisioned from code.

## 01Request flow

On the host, `vagrant up` builds a VM from the Vagrantfile, which runs an Ansible playbook inside the VM to install Docker and stage the build context. Docker then builds and runs the container on the VM's internal network only — nothing is forwarded back out to the host.

## 02Folder structure

```
sshole-poc/
├── README.md
├── Vagrantfile
├── ansible/
│   ├── provision.yml
│   ├── inventory.ini
│   └── roles/
│       ├── base/
│       │   └── tasks/main.yml
│       └── docker/
│           └── tasks/main.yml
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── config/
│       └── sshd_config
├── scripts/
│   ├── run.sh
│   └── check-logs.sh
└── docs/
    └── architecture.svg
```

root README.md\
Context, how to run, how to verify, limitations.

infra Vagrantfile\
VM box, host-only network, triggers Ansible provisioner.

infra ansible/\
Generic provisioning — installs Docker, stages the build context. No exploit-specific content.

target docker/Dockerfile\
The vulnerable service definition — yours to fill in from the advisory.

target docker/docker-compose.yml\
Documents ports/volumes explicitly — internal network only.

tools scripts/run.sh\
One-command chain: vagrant up → provision → build → run.

tools scripts/check-logs.sh\
Greps sshd logs for accepted-password events on no-password accounts.

Scaffolding only — the Dockerfile's account/hash configuration is left for you to complete.