# System Architecture

## Power Path
Battery Pack (48â€¯V nominal) â†’ Main Fuse â†’ Pre-charge Resistor â†’ Contactor â†’ Motor Controller â†’ BLDC Motor
                                        â†˜ DC-DC 48â†’12â€¯V â†’ Lights/Logic

## Control Path
PAS Sensor + Throttle + Brake Switches â†’ MCU (ESP32) â†’ UART/CAN â†’ Motor Controller
BMS â†’ MCU â†’ Display/BLE â†’ User/App

## Data Interfaces
- MCU â†” Motor Controller: UART @115200 or CAN 500 kbps
- MCU â†” BMS (e.g., Daly): UART @9600
- MCU â†” Display: I2C or UART
- MCU â†” Phone: BLE (Nordic UART or custom GATT)

See `docs/wiring-diagram.md` for wiring details.