ARG ALPINE_VERSION=3.19

FROM alpine:${ALPINE_VERSION} AS build
ARG OPENSSH_VERSION=9.6p1

RUN apk update \
    && apk add --no-cache build-base zlib-dev openssl-dev linux-headers curl musl-dev patch

RUN curl -fsSLO https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz \
    && tar xzf openssh-${OPENSSH_VERSION}.tar.gz \
    && cd openssh-${OPENSSH_VERSION} \
    && CPPFLAGS="-D_FORTIFY_SOURCE=0" ./configure --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-path=/var/empty \
    && make -j"$(nproc)" \
    && make DESTDIR=/out install-nokeys

FROM alpine:${ALPINE_VERSION}
RUN apk update \
    && apk add --no-cache openssl zlib \
    && mkdir -p /var/empty && chmod 755 /var/empty \
    && (id sshd 2>/dev/null || adduser -S -D -H -h /var/empty -s /sbin/nologin sshd) \
    # 1. Utilisateur 'lab' (connexion par clé SSH)
    && adduser -D lab \
    && passwd -d lab \
    && install -d -m 0700 -o lab -g lab /home/lab/.ssh \
    # 2. 'Oumar' AVEC mot de passe valide
    && adduser -D oumar \
    && echo "oumar:ComplexPass123!" | chpasswd \
    # 3. 'Clelie' sans mot de passe
    && adduser -D Clelie \
    && sed -i 's/^Clelie:!:/Clelie:*:/' /etc/shadow

COPY --from=build /out/ /
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 22
CMD ["/usr/local/bin/start.sh"]