# Bootloader Analysis

## Bootloader Identification

Boot banner upon device startup:

```
U-Boot 2020.04-00011-gddf6f040-dirty (Jun 17 2024 - 18:12:02 +0800), Build: jenkins-Compile_64位(10.188.40.119)-7385
U-Boot code: 5C000400 -> 5C095BEC BSS: -> 5C0BD52C
Model: AXERA AX620E_Qnand Board
```

Version:
U-Boot 2020.04-00011-gddf6f040-dirty

## Interrupt Window

Observed the following UART output during initial boot:

`Press Ctrl+B to abort autoboot in 2 seconds`

Pressing Ctrl+B after rebooting allows for successful interruption and unauthenticated access to the U-Boot shell.

## Shell Access

Prompt:
uboot #

Many commands available:

```
uboot # help
?         - alias for 'help'
adc       - ADC sub-system
axera_boot- axera boot
axera_ota - ota from tftp server
base      - print or set address offset
bdinfo    - print Board Info structure
bind      - Bind a device to a driver
blkcache  - block cache diagnostics and control
boot      - boot default, i.e., run 'bootcmd'
bootd     - boot default, i.e., run 'bootcmd'
bootm     - boot application image from memory
bootp     - boot image via network using BOOTP/TFTP protocol
<...>
printenv  - print environment variables
protect   - enable or disable FLASH write protection
pwm       - pwm config
random    - fill memory with random pattern
reset     - Perform RESET of the CPU
run       - run commands in an environment variable
saveenv   - save environment variables to persistent storage
sd_update - download mode
setenv    - set environment variable
<...>
```

A few commands such as `printenv`, `setenv`, and `savenv` stand out immediately

## Restrictions

- No authentication needed
- Full command access through UART
- Environment variables read and writable
- Flash access commands are available

## Security Implications

Unauthenticated bootloader access via exposed UART header.

Potential impact:

- Firmware modification
- Kernel parameter changes
- Persistent compromise

Further testing required to determine:

- Secure boot enforcement?
- Flash write protections?
- Boot argument tampering possibilities?
