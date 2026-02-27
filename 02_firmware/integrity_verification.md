# Integrity Verification

## Overview

The device implements a boot-time RSA signature verification mechanism that checks the integrity of certain files in the `/program` partition before allowing the system to fully initialize. This mechanism was discovered after an accidental file modification caused a boot failure during a prior session.

## Discovery

While editing `/program/bin/mware_init.sh` using `vi`, an extra newline was unintentionally introduced. On the next reboot, the device failed to boot, printing:

```
verify signature fail, exit!
```

The `/program` partition was unmounted and the boot sequence aborted. Diagnosis proved to be challenging due to: no `sha256sum` binary on the device, a non-human readable `signature.bin`, misleading file timestamps on the device, and no indication of which specific file had changed.

The issue was resolved by removing the extra newline from `mware_init.sh`, restoring the SHA256 hash to its original state.

## Mechanism

After `S30ambrwfs` mounts `/program`, `rcS` invokes `encrypt_sign_tool` before continuing with the remaining init scripts.

```bash
#!/bin/sh
for initscript in /etc/init.d/S[0-9]*
do
	if [ -x $initscript ] ;
	then
		echo "[RCS]: $initscript"
		$initscript
		if [ "$initscript" == "/etc/init.d/S30ambrwfs" ]; then
			cmd_output=`/usr/sbin/encrypt_sign_tool 3 /program/bin/filelist.txt /usr/sbin/program_public.key /program/bin/signature.bin`
			if [ -z "`echo $cmd_output | grep 'rsa verify ok'`" ]; then
				echo "verify signature fail, exit!"
				umount /program
				exit 1
			fi
		fi
	fi
done
```

The tool computes a SHA256 hash over the files listed in `filelist.txt` and verifies it against `signature.bin` using `program_public.key`.
The scheme is RSA-2048. If verification fails, `/program` is unmounted and boot continues into uvsh without the firmware properly running.

## Files Checked (`/program/bin/filelist.txt`)

```
/program/bin/mwareserver
/program/bin/mware_init.sh
/program/bin/init.sh
```

Signing takes Uniview's private key and can't be forged.

## Weaknesses

### Incomplete File Coverage

`filelist.txt` only covers three files. The scripts used as shell escape vectors (see `shell_escape.md`) aren't listed and are never verified.
An attacker can freely modify these files without triggering the integrity check.

### Write-Time vs Boot-Time Enforcement

The check only runs at boot, it doesn't prevent modification of covered files. An attacker with a single-user mode root shell can modify any file on `/program`
freely. The integrity check will not trigger until after the next reboot.

## Security Implications

This mechanism provides a partial integrity guarantee that doesn't cover the full attack surface.
The files most relevant to privelege escalation are out of the scope of this partial check, and modifying covered files isn't prevented only detected on the subsequent boot.
An attacker with single-user mode access can achieve persistence without ever triggering the verification failure.
