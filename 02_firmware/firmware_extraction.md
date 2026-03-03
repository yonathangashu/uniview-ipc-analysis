# Firmware Extraction

## Overview

With root shell access achieved, the next goal is leveraging that shell to extract device firmware for analysis.
The device comes with a microSD card slot.

Running `df -h` after inserting a microSD card into the slot yields the following output:

```bash
root@root:/$ df -h
Filesystem                Size      Used Available Use% Mounted on
df: /dev/pts: No such file or directory
tmpfs                    88.5M      1.1M     87.4M   1% /tmp
tmpfs                    52.1M    132.0K     52.0M   0% /var
devtmpfs                 50.9M         0     50.9M   0% /dev
tmpfs                    88.5M      1.1M     87.4M   1% /root
ubi0:program             79.9M     44.5M     35.4M  56% /program
ubi1:config               4.3M    340.0K      3.7M   8% /config
ubi2:cfgbak               2.5M    164.0K      2.1M   7% /cfgbak
ubi3:calibration          2.5M     24.0K      2.3M   1% /calibration
tmpfs                    52.1M    132.0K     52.0M   0% /etc
/dev/mmcblk0p1          510.0M     85.5M    424.5M  17% /mnt/sdcard
```

## Approach

### Live Filesystem Copy

The primary extraction method was simply using root shell access and the mounted sdcard to copy the runtime filesystem directly from the live device using `cp -rP` on
all mounted partitions:

```bas
cp -rP /program/ /mnt/sdcard/
cp -rP /config/ /mnt/sdcard/
cp -rP /cfgbak/ /mnt/sdcard/
cp -rP /calibration/ /mnt/sdcard/
cp -rP /etc/ /mnt/sdcard/
cp -rP /tmp /mnt/sdcard/
cp -rP /var /mnt/sdcard/
cp -rP /lib /mnt/sdcard/
cp -rP /bin /mnt/sdcard/
cp -rP /sbin /mnt/sdcard/
cp -rP /usr /mnt/sdcard/
```

This leverages the UBI layer's transparent bad block remapping, producing a clean and complete copy of each partitions's content as seen at runtime.

### Raw MTD Dump

A dump of the raw MTD block devices was also obtained using `dd conv=noerror,sync` for archival purposes. Offline UBIFS extraction from these images did not yield usable results.

```bash
dd if=/dev/mtd0 of=/mnt/sdcard/uniview_full_fw.bin bs=131072 conv=noerror,sync
dd if=/dev/mtd12 of=/mnt/sdcard/uniview_program_flash.bin bs=131072 conv=noerror,sync
```

## Preqrequisites

- Root shell on line firmware (see shell_escape.md)
- microSD card with sufficient free space
