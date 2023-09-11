#!/bin/bash

# Check if PASSWORD is set, if set change root password and allow root login with password
if [ ! -z "$PASSWORD" ]; then
    echo "root:$PASSWORD" | chpasswd
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
fi

# Check if PUBKEY_URL is set, if set add public key to authorized_keys
if [ ! -z "$PUBKEY_URL" ]; then
    mkdir -p /root/.ssh
    curl -sSL $PUBKEY_URL >> /root/.ssh/authorized_keys
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
fi

/usr/sbin/sshd -D -e -p 2222