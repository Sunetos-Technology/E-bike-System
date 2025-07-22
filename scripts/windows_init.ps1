# windows_init.ps1  (run from repo root)
$ErrorActionPreference = 'Stop'
$root = Get-Location
Write-Host "Working in $root" -ForegroundColor Cyan

function Write-UTF8 {
    param($Path, $Content)
    $dir = Split-Path $Path
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText((Join-Path $root $Path), $Content, $enc)
    Write-Host "Created $Path" -ForegroundColor Green
}

# Folders
$dirs = @(
  "docs",
  "hardware/battery_pack",
  "hardware/motor_controller_box",
  "hardware/sensors_and_hmi",
  "hardware/enclosures",
  "firmware/controller_fw/src",
  "firmware/display_fw/src",
  "firmware/bms_tools",
  "software/mobile_app",
  "manufacturing",
  "scripts"
)
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

# ---------- Files ----------
Write-UTF8 "README.md" @'
# eBike System – Complete Modular Project

This repository contains all modules to design, build, and program a full electric bicycle: hardware (schematics/placeholders), firmware, software, docs, and manufacturing guides.

See `docs/system-architecture.md` to understand how everything fits.

## Quick Start
1. Read `docs/system-architecture.md` and choose your specs (voltage, power, legal class).
2. Build firmware in `firmware/controller_fw` with PlatformIO (ESP32 example).
3. Populate hardware schematics in KiCad files under `hardware/*`.
4. Use `scripts/commit_push.ps1` to commit & push to GitHub.

---

## Repo Structure
./
├── docs/
├── hardware/
├── firmware/
├── software/
├── manufacturing/
└── scripts/

sql
Copy
Edit

Each folder contains its own README or files described below.

Enjoy building! 🚲⚡
'@

Write-UTF8 "docs/system-architecture.md" @'
# System Architecture

## Power Path
Battery Pack (48 V nominal) → Main Fuse → Pre-charge Resistor → Contactor → Motor Controller → BLDC Motor
                                        ↘ DC-DC 48→12 V → Lights/Logic

## Control Path
PAS Sensor + Throttle + Brake Switches → MCU (ESP32) → UART/CAN → Motor Controller
BMS → MCU → Display/BLE → User/App

## Data Interfaces
- MCU ↔ Motor Controller: UART @115200 or CAN 500 kbps
- MCU ↔ BMS (e.g., Daly): UART @9600
- MCU ↔ Display: I2C or UART
- MCU ↔ Phone: BLE (Nordic UART or custom GATT)

See `docs/wiring-diagram.md` for wiring details.
'@

Write-UTF8 "docs/wiring-diagram.md" @'
# Wiring Diagram (ASCII Overview)

48V+ ─ Fuse(40A) ─ Pre-charge(100Ω) ─┐
                                   │
                              Contactor ─── Controller VIN+
                                   │                    ┌──────────┐
48V- ────────────────────────────────────────────────────┤Ctrl VIN- ├──> BLDC Motor (3-phase)
                                                         └──────────┘
PAS Sensor (5V,GND,Signal) ──> MCU ADC/INT
Throttle (5V,GND,0-4V) ──────> MCU ADC
Brake Switches ──────────────> MCU GPIO (cuts power)
BMS UART TX/RX ──────────────> MCU UART2
DC-DC 48→12V ──> Lights, Horn, etc.

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
'@

Write-UTF8 "docs/requirements-and-standards.md" @'

Requirements & Standards
Legal:

EU: EN 15194 (<=250 W, 25 km/h assist, no throttle continuous power)

US: Class 1/2/3 rules (check state/city specifics)

Electrical Safety: UL 2271 (battery), UL 2849 (e-bike systems)

Ingress Protection: Target IP65 for controller/battery enclosures

Thermal Limits: Maintain cells <60 °C, controller <85 °C

EMC/EMI: Keep high-current wiring twisted/short, add filtering if needed
'@

Write-UTF8 "docs/test-plan.md" @'

Test Plan
Firmware Unit Tests
Sensor reading bounds (0–1 throttle, brake boolean)

UART parser for BMS/motor responses

Functional Tests
PAS engages motor only when pedaling

Throttle control linearity

Brake cutoffs stop motor within <50 ms

BMS comms show accurate SOC/voltage

Environmental
Water spray (IPX5)

Vibration: simulate road shocks

Thermal soak @ 40 °C ambient
'@

Write-UTF8 "docs/bom-template.csv" @'
Module,Item,Qty,Part Number,Vendor,Unit Cost,Notes
Battery Pack,18650 Cell 3Ah,52,Samsung 30Q,Mouser,3.2,13S4P
Battery Pack,BMS 13S 40A,1,Daly 13S,AliExpress,25,
Controller,FOC Controller 60V 50A,1,VESC 6 clone,,120,
MCU,ESP32 DevKitC,1,ESP32-WROOM-32,Digikey,6,
Sensors,PAS Cadence Sensor,1,C961,,8,
Sensors,Throttle Hall,1,Generic,,5,
Harness,XT90 Connector,2,XT90S,,3,
'@

Write-UTF8 "hardware/battery_pack/README.md" @'

Battery Pack (13S4P Example)
Cells: 13 series x 4 parallel = 52 cells (48V nominal)

BMS: Daly 13S 40A, UART output

Fuse: 40A on P+

Pre-charge: 100 Ω 5 W resistor in parallel with contactor

Assembly Notes
Spot weld nickel strips, do NOT solder directly to cells

Add insulation rings, fish paper, Kapton

Seal pack in shrink + hard case if possible
'@

Write-UTF8 "hardware/battery_pack/battery_pack.kicad_sch" @'
KiCad schematic placeholder for battery pack.
Blocks:

13S cell groups (B1..B13)

BMS connection (B-, C-, P-, B1..B13)

Fuse on P+

Contactor + pre-charge resistor

XT90 output connector
'@

Write-UTF8 "hardware/battery_pack/precharge_contactors.sch" @'
Pre-charge & contactor circuit placeholder:

Coil driver (MOSFET + flyback diode)

Pre-charge resistor across main contactor

Pushbutton or MCU control line
'@

Write-UTF8 "hardware/motor_controller_box/README.md" @'

Motor Controller Box
Includes wiring between controller, motor phases, hall sensors, throttle, PAS, brakes, and MCU.
Use waterproof connectors (IP67). Keep phase wires short and sized for current.
'@

Write-UTF8 "hardware/motor_controller_box/controller_wiring.sch" @'
Placeholder schematic: controller pinout, hall sensor wiring, throttle/PAS inputs.
'@

Write-UTF8 "hardware/sensors_and_hmi/README.md" @'

Sensors & HMI
PAS cadence or torque sensor

Throttle (0–4 V hall type)

Brake levers with cut-off switch (normally closed to GND)

Optional IMU, GPS, buttons
'@

Write-UTF8 "hardware/sensors_and_hmi/pas_sensor.sch" @'
PAS sensor schematic placeholder.
'@
Write-UTF8 "hardware/sensors_and_hmi/throttle.sch" @'
Throttle schematic placeholder.
'@
Write-UTF8 "hardware/sensors_and_hmi/brake_cutoff.sch" @'
Brake cutoff schematic placeholder.
'@

Write-UTF8 "hardware/enclosures/README.md" @'

Enclosures
Battery box: 3D printed/metal enclosure, IP65

Controller housing with heat sink exposure

Display/Control head waterproofing
'@

Write-UTF8 "hardware/enclosures/battery_box.step" @'
STEP_PLACEHOLDER
'@

Write-UTF8 "firmware/controller_fw/platformio.ini" @'
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
lib_deps =
bblanchon/ArduinoJson@^6.21.2
'@

Write-UTF8 "firmware/controller_fw/src/config.h" @'
#pragma once
#define PIN_THROTTLE 34
#define PIN_PAS 35
#define PIN_BRAKE_L 32
#define PIN_BRAKE_R 33
#define UART_MOTOR_NUM 1
#define UART_BMS_NUM 2
#define MAX_CURRENT_A 25.0
#define MAX_SPEED_KMH 45.0
'@

Write-UTF8 "firmware/controller_fw/src/sensors.h" @'
#pragma once
#include <Arduino.h>
struct SensorData {
float throttle; // 0.0–1.0
float cadence_hz;
bool brake_active;
};
void sensors_init();
SensorData sensors_read();
'@

Write-UTF8 "firmware/controller_fw/src/sensors.cpp" @'
#include "sensors.h"
#include "config.h"
static uint32_t last_pas_time = 0;
static volatile uint32_t pas_pulse_interval = 0;
static void IRAM_ATTR pas_isr() {
uint32_t now = micros();
pas_pulse_interval = now - last_pas_time;
last_pas_time = now;
}
void sensors_init() {
pinMode(PIN_BRAKE_L, INPUT_PULLUP);
pinMode(PIN_BRAKE_R, INPUT_PULLUP);
attachInterrupt(digitalPinToInterrupt(PIN_PAS), pas_isr, RISING);
}
SensorData sensors_read() {
SensorData d{};
d.throttle = analogRead(PIN_THROTTLE) / 4095.0;
d.cadence_hz = (pas_pulse_interval > 0) ? 1e6f / pas_pulse_interval : 0.0f;
d.brake_active = (digitalRead(PIN_BRAKE_L) == LOW) || (digitalRead(PIN_BRAKE_R) == LOW);
return d;
}
'@

Write-UTF8 "firmware/controller_fw/src/control.h" @'
#pragma once
#include "sensors.h"
float compute_assist_current(const SensorData &d);
'@

Write-UTF8 "firmware/controller_fw/src/control.cpp" @'
#include "control.h"
#include "config.h"
#include <Arduino.h>
float compute_assist_current(const SensorData &d) {
if (d.brake_active) return 0.0f;
float pas_factor = constrain(d.cadence_hz / 2.0f, 0.0f, 1.0f);
float throttle_current = d.throttle * MAX_CURRENT_A;
float pas_current = pas_factor * (MAX_CURRENT_A * 0.6f);
return max(throttle_current, pas_current);
}
'@

Write-UTF8 "firmware/controller_fw/src/comms_uart.cpp" @'
#include <HardwareSerial.h>
#include <ArduinoJson.h>
#include "config.h"
HardwareSerial MotorSerial(UART_MOTOR_NUM);
void motor_uart_init() {
MotorSerial.begin(115200, SERIAL_8N1, 16, 17); // RX=16 TX=17 example
}
void motor_set_current(float amps) {
StaticJsonDocument<128> doc;
doc["cmd"] = "set_current";
doc["value"] = amps;
serializeJson(doc, MotorSerial);
MotorSerial.write('\n');
}
'@

Write-UTF8 "firmware/controller_fw/src/main.cpp" @'
#include <Arduino.h>
#include "sensors.h"
#include "control.h"
extern void motor_uart_init();
extern void motor_set_current(float amps);
void setup() {
Serial.begin(115200);
sensors_init();
motor_uart_init();
}
void loop() {
SensorData d = sensors_read();
float amps = compute_assist_current(d);
motor_set_current(amps);
delay(20);
}
'@

Write-UTF8 "firmware/display_fw/platformio.ini" @'
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
lib_deps =
adafruit/Adafruit SSD1306@^2.5.9
adafruit/Adafruit GFX Library@^1.11.5
'@

Write-UTF8 "firmware/display_fw/src/main.cpp" @'
#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_SSD1306.h>
Adafruit_SSD1306 disp(128, 64, &Wire);
void setup(){
disp.begin(SSD1306_SWITCHCAPVCC, 0x3C);
disp.clearDisplay();
disp.setTextSize(1); disp.setTextColor(SSD1306_WHITE);
disp.setCursor(0,0);
disp.println("SUNET eBike");
disp.display();
}
void loop(){
delay(500);
}
'@

Write-UTF8 "firmware/bms_tools/README.md" @'

BMS Tools
Example Python scripts to read Daly BMS over UART.
'@

Write-UTF8 "firmware/bms_tools/daly_uart_logger.py" @'
import serial, time
PORT = "COM6" # adjust for your system
ser = serial.Serial(PORT, 9600, timeout=1)
frame = bytes.fromhex("A5 40 90 08 00 00 00 00 00 00 00 00 00 00 00 00")
ser.write(frame)
reply = ser.read(128)
print(reply.hex())
'@

Write-UTF8 "software/mobile_app/README.md" @'

Mobile App (Optional)
BLE connection to MCU (ESP32)

Services:

UART TX/RX for data and commands

Battery status characteristic
Use React Native or Flutter. This folder will hold the app project.
'@

Write-UTF8 "software/mobile_app/ble_proto.md" @'

BLE Protocol
Service UUID: 6E400001-B5A3-F393-E0A9-E50E24DCCA9E (Nordic UART)

RX Char: 6E400002-... (Write)

TX Char: 6E400003-... (Notify)
JSON frames example:
{ "type": "telemetry", "speed": 23.5, "soc": 78 }
'@

Write-UTF8 "manufacturing/assembly_instructions.md" @'

Assembly Instructions
Assemble battery pack per hardware/battery_pack/README.md

Mount motor & controller to frame, route cables

Install sensors (PAS, throttle, brakes)

Waterproof connectors

Run firmware smoke test (PAS, throttle)
'@

Write-UTF8 "manufacturing/qa_checklist.md" @'

QA Checklist
 Pack voltage correct (54.6V full)

 Fuse installed / correct rating

 Controller powers and responds to UART

 PAS starts motor assist

 Brake cutoff works

 No short circuits, wiring labeled
'@

Write-UTF8 "manufacturing/service_manual.md" @'

Service Manual
Common Issues
No assist: check brake switches, PAS sensor alignment

Cutouts under load: check BMS overcurrent, controller temp

Display blank: check 12V DC-DC and I2C wiring
'@

Write-UTF8 "scripts/commit_push.ps1" @'
param([string]$msg = "Update")
git add -A
git commit -m "$msg"
git push
'@

Write-Host "`nAll files created. Next: init git, commit, push." -ForegroundColor Cyan