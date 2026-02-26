# Filesystem

## Overview

Running `mount` on the live device yields the following output:

```bash
root@root:~$ mount
rootfs on / type rootfs (rw)
evpts on /dev/pts type devpts (rw,relatime,mode=600,ptmxmode=000)
proc on /proc type proc (rw,nosuid,nodev,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,relatime)
tmpfs on /tmp type tmpfs (rw,relatime,size=90672k)
tmpfs on /var type tmpfs (rw,relatime)
devtmpfs on /dev type devtmpfs (rw,relatime,size=52076k,nr_inodes=13019,mode=755)
tmpfs on /root type tmpfs (rw,relatime,size=90672k)
ubi0:program on /program type ubifs (rw,relatime,assert=read-only,ubi=0,vol=0)
ubi1:config on /config type ubifs (rw,sync,relatime,assert=read-only,ubi=1,vol=0)
ubi2:cfgbak on /cfgbak type ubifs (rw,sync,relatime,assert=read-only,ubi=2,vol=0)
ubi3:calibration on /calibration type ubifs (ro,sync,relatime,assert=read-only,ubi=3,vol=0)
tmpfs on /etc type tmpfs (rw,relatime)
pstore on /sys/fs/pstore type pstore (rw,relatime)
```

## Partition Analysis

### `/` - Root Filesystem

Mounted as `rootfs` from ramdisk, so changes don't persist across reboots. This is the minimal boot env loaded into memory at startup.

### `/program` - UBIFS App Partition

The primary application partition. Vendor binaries, libraries, initialization scripts, and the web interface are all stored here.
This partition is writable from single user mode, which is the basis for the escape and persistence techniques documented in `shell_escape.md`

### `/etc`, `/root`, `/var`, `/tmp` - Volatile Filesystems

All mountes as `tmpfs`. The contents are populated at boot from `/program` and they get discarded on reboot.
This explains why changing `/etc/passwd` and `/etc/shells` doesn't survive reboot.

### `/config` - Config Partition

The persistent configuration storage. Mounted read-write w/ sync, so writes are commited to flash immediately. Contains general device configuration, openssl config, and some device credentials. Could be a high value target for credential extracting.

### `/cfgbak` - Config Backup Partition

A clone of some important parts of `/config`.
