#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

vagrant ssh -c 'bash -s' <<'VM_SCRIPT'
set -euo pipefail
cd /vagrant/docker

echo "== Version d'OpenSSH =="
sudo docker compose exec -T sshd sshd -V 2>&1 | head -1 || true

echo
echo "== Événements d'authentification =="
sudo docker compose logs --no-log-prefix sshd 2>&1 \
  | grep -E "Invalid user|Failed|Accepted|Connection closed|Disconnected" \
  | tail -n 50 || echo "(aucun événement)"
VM_SCRIPT