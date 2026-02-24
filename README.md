# Uniview IP Camera Security Analysis

Independent security assessment of a Uniview IP camera, examining:

- Hardware security (UART, bootloader)
- Firmware vulnerabilities
- Network attack surface

## Target

The target for this assessment is the Uniview SC-3243-IWPS-F28 Fixed IR Dome Camera. This camera is used in commercial settings for physical site security.

## Scope

This analysis was performed in a controlled lab environment on personally owned hardware.
No unauthorized systems were accessed.

## Current Status

- Device disassembled
- UART interface identified and validated
- U-Boot shell access obtained
- Boot logs captured
- Single-user mode boot achieved via modified `bootargs`
- Root shell access obtained on live firmware
- Default credentials identified and validated
- Restricted shell (`uvsh`) analyzed (binary inspection, command enumeration)
- Shell escape achieved via writable `/program` partition
- Persisitent root command execution confirmed via writable init scripts on `/program`
- `dropbear` deployed and configured for key-based SSH access
- Remote root SSH access validated over LAN
- Network attack surface enumerated: HTTP(80), RTSP(554), and proprietary middleware identified

## Acknowledgements

This research was informed by prior work from Brown Fine Security; all experiments performed independently.
