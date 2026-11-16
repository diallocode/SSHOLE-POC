FROM alpine:3.21

RUN apk add --no-cache openssh \
    # 1. Creation de l'utilisateur 'lab' (connexion par clé SSH)
    && adduser -D lab \
    && passwd -d lab \
    && install -d -m 0700 -o lab -g lab /home/lab/.ssh \
    # 2. Creation de 'dummyuser' AVEC mot de passe valide
    && adduser -D dummyuser \
    && echo "dummyuser:ComplexPass123!" | chpasswd \
    # 3. Creation de 'targetuser' (sans mot de passe)
    && adduser -D targetuser \
    && sed -i 's/^targetuser:!:/targetuser:*:/' /etc/shadow 
CMD ["sh", "-ec", "install -m 0600 -o lab -g lab /run/lab.pub /home/lab/.ssh/authorized_keys; ssh-keygen -A; exec /usr/sbin/sshd -D -e"]