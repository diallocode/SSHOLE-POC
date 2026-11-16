#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

vagrant up --provider=vmware_desktop

vagrant ssh -c 'bash -s' <<'VM_SCRIPT'
set -euo pipefail
cd /vagrant/docker

fail() {
  printf '\nÉCHEC — %s\n' "$1" >&2
  sudo docker compose logs --tail=50 sshd >&2 || true
  exit 1
}

if [[ ! -f lab_key ]]; then
  ssh-keygen -q -t ed25519 -N '' -f lab_key -C 'compose-lab'
fi

# Régénère la clé publique à partir de la clé privée en cours.
ssh-keygen -y -f lab_key > lab.pub

sudo docker compose up -d --build sshd ||
  fail "Impossible de démarrer sshd."

sudo docker compose run --rm -T client sh -ec '
  for attempt in $(seq 1 15); do
    if ssh-keyscan -T 2 -t ed25519 sshd > /tmp/known_hosts 2>/dev/null; then
      break
    fi
    sleep 1
  done
  test -s /tmp/known_hosts

  install -m 0600 /run/lab_key /tmp/lab_key

  ssh_test() {
    LC_ALL=C ssh -F /dev/null \
      -o BatchMode=yes -o IdentitiesOnly=yes -o IdentityAgent=none \
      -o ConnectTimeout=5 -o StrictHostKeyChecking=yes \
      -o UserKnownHostsFile=/tmp/known_hosts "$@"
  }

  result=$(ssh_test -i /tmp/lab_key lab@sshd whoami)
  test "$result" = lab
  printf "OK — connexion avec la clé autorisée (whoami = %s)\n" "$result"

  if result=$(ssh_test -o IdentityFile=none lab@sshd whoami 2>&1); then
    printf "Connexion acceptée sans clé\n" >&2
    exit 1
  fi

  case "$result" in
    *"Permission denied (publickey)"*)
      printf "OK — connexion sans clé refusée\n"
      ;;
    *)
      printf "Erreur inattendue : %s\n" "$result" >&2
      exit 1
      ;;
  esac
' || fail "La vérification SSH a échoué."
VM_SCRIPT