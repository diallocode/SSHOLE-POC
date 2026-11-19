#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

vagrant up --provider=vmware_desktop
vagrant ssh -c 'cd /vagrant/docker && sudo docker compose up -d --build sshd'

echo "Lab prêt. Connecte-toi avec :"
echo "  vagrant ssh"
echo "  sudo docker compose -f /vagrant/docker/compose.yml exec sshd sh"
echo "  (depuis là, ou avec openssh-client installé dans la VM : ssh dummyuser@<ip conteneur>)"