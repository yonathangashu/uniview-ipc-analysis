# UART Interface Analysis

## Physical Inspection

The device was disassembled by removing three screws from the case to expose the top PCB.
An unpopulated 4-pin header was identified in a corner of the top PCB, adjacent to the ribbon cable connecting to the bottom PCB.

Initial Hypothesis: Likely UART debugging interface due to pin grouping and silkscreen labeling (J4).

## Pin Identification

Investigating the suspected UART header at J4 using a digital multimeter:

- Identified UART voltage level as 3.3v
- Pin 1: VCC (idle ~3.3v)
- Pin 2: TX (fluctuating voltage on startup)
- Pin 3: RX (idle ~3.3v)
- Pin 4: GND (confirmed via continuity to board ground)

## Serial Connection

Adapter: [Tigard](https://github.com/tigard-tools/tigard)

After hooking the Tigard's RX & TX to the IPC's TX & RX respectively, tested serial connection with the most common UART baud rate of 115200.
Achieved successful connection and initial power-on output, confirming the initial pinout identification.

## Initial Ouput

Upon powering the device on, serial output displayed U-boot as the bootloader and identified the exact board model.

See full logs here: assets/logs/bootlog_capture_20260217.txt

## Security Implications

Exposed UART interface with no obfuscation.
Provides low-level boot visibility and potential control.

Physical access required.
