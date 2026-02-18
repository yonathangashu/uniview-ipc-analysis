# Privilege Model Analysis

## Root Account

Entry from `etc/passwd`:

```
root:dIkAjCy0Zma2s:0:0:Linux User,,,:/root:/usr/bin/uvsh
```

Observations:

- UID: 0 (root)
- Default login shell is`/usr/bin/uvsh`
- Not `/bin/sh ` or `/bin/bash`

## Restricted Shell

By default, the root account is configured to use `/usr/bin/uvsh`.

This suggests a vendor-enforced restricted environment with command whitelisting is all that is intended to be available to the user.
This is likely intended to prevent full system access even as root user.

However, booting with the `single` kernel parameter bypasses this normal login procedure and directly pops a root shell.

This bypasses:

- Password authentication
- Restricted shell enforcement
