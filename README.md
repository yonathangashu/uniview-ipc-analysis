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

## Acknowledgements

This research was informed by prior work from Brown Fine Security; all experiments performed independently.
