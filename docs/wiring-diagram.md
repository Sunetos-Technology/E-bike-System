# Wiring Diagram (ASCII Overview)

48V+ â”€ Fuse(40A) â”€ Pre-charge(100Î©) â”€â”
                                   â”‚
                              Contactor â”€â”€â”€ Controller VIN+
                                   â”‚                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
48V- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤Ctrl VIN- â”œâ”€â”€> BLDC Motor (3-phase)
                                                         â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
PAS Sensor (5V,GND,Signal) â”€â”€> MCU ADC/INT
Throttle (5V,GND,0-4V) â”€â”€â”€â”€â”€â”€> MCU ADC
Brake Switches â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€> MCU GPIO (cuts power)
BMS UART TX/RX â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€> MCU UART2
DC-DC 48â†’12V â”€â”€> Lights, Horn, etc.

```mermaid
graph TD
  BATT[Battery Pack 48V] -->|Fuse| PRE[Pre-charge & Contactor]
  PRE --> CTRL[Motor Controller]
  CTRL --> MOTOR[BLDC Motor]
  CTRL -->|UART/CAN| MCU[ESP32 MCU]
  PAS[Pedal Assist Sensor] --> MCU
  THR[Throttle] --> MCU
  BRK[Brake Switches] --> MCU
  BMS -->|UART| MCU
  BATT --> DCDC[DC-DC 48->12V]
  DCDC --> LIGHTS[Lights/Horn]
  MCU -->|BLE| PHONE[Mobile App]