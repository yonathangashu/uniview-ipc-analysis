# Shell Escape

## Overview

The restricted vendor shell `uvsh` can be escaped to obtain a full root shell on the live firmware by invoking a modified script from within the whitelisted command set.

## Root Cause

The restricted shell model relies on command whitelisting but permits execution of vendor-maintained scripts located on a writable UBIFS partition.

Because these scripts execute with root privileges and are not integrity-protected, modification of a whitelisted script allows arbitrary command execution within the trusted execution path of `uvsh`.

## Prequisites

- Physical UART access (see `uart_analysis.md`)
- Single user mode root shell (see `boot_param_manipulation.md`)
- Program partition mounted (see `mnt_prgm_part.sh`)

## Method

While in the single user mode root shell, and after mounting the `program` partition, navigate to `/program/bin`.
A writable script within the `/program/bin` directory (e.g., `checksysready.sh`) can be modified to invoke `/bin/sh`. Since this script is accessible via the `uvsh` command whitelist, invoking it from the restricted shell results in execution of a full root shell.
Hard reboot the device.
At the uvsh prompt, authenticate with the default credentials (root:uniview), then run: `checksysready`

This spawns a full root shell on the live firmware.

## Persistence

The /program partition is written to NAND flash via UBIFS.
Modifications made while mounted in single user mode survive reboot because the write occurs before the normal boot sequence remounts /program as read-only.

## Impact

- Complete bypass of restricted shell enforcement
- Arbitrary command execution as root
- Persistence across reboot due to writable UBIFS partition
- Requires only prior physical access and default credentials
