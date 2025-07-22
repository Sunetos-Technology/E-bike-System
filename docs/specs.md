***# SUNET eBike – Final Specs***



***## Legal / Usage***

***- Region/Class: US Class 2 (throttle + PAS, ≤750 W, top assist 20 mph / 32 km/h)***

***- Intended use: Commuter / light cargo***



***## Electrical***

***- System voltage: 48 V nominal (13S Li‑ion), 54.6 V full***

***- Battery pack: 13S5P Samsung 35E (3.5 Ah) → 17.5 Ah, ~840 Wh***

***- BMS: JBD/LLT 13S 60 A w/ UART telemetry (OVP/UVP/OCP/OTP, balancing)***

***- Main fuse: 40 A ANL***

***- Controller: VESC 75/100 (60 V max, 100 A peak phase, open UART/CAN)***

***- DC‑DC: 48 V→12 V 5 A buck for lights/horn/logic aux***



***## Motor / Drivetrain***

***- Motor: Bafang RM G060.750.DC rear geared hub, 750 W, hall sensors, 12T***

***- Wheel: 27.5” (or 700c) double‑wall rim, 13/14g spokes***

***- Freewheel/cassette: 8–10 speed compatible (spec final TBD)***

***- Human drivetrain: Standard crankset \& derailleur (unchanged)***



***## Control \& Sensors***

***- MCU: ESP32‑WROOM‑32 DevKitC***

***- PAS: 12‑magnet cadence sensor (digital pulse)***

***- Throttle: Hall twist throttle (0–4.2 V analog)***

***- Brake cutoffs: NC microswitch in both levers (logic LOW = braking)***

***- Wheel speed sensor: magnet + hall on rear wheel (optional if using controller’s hall feedback)***

***- Temp sensors: in motor stator (NTC) and on battery pack (via BMS)***



***## HMI***

***- Display: Optional 0.96” OLED (SSD1306) on I2C***

***- Buttons: Mode up/down (GPIO)***

***- Mobile app: BLE UART service for telemetry \& settings***



***## Enclosures / IP***

***- Battery enclosure: IP65 box mounted in frame triangle***

***- Controller box: IP65 aluminum with external heatsink***

***- Wiring connectors: Waterproof (Higo/Julet or IP67 circulars)***



***## Targets***

***- Range: 40–60 km mixed assist (depends on rider \& terrain)***

***- Peak assist current: 25 A battery side (≈1200 W peak electrical, ~750 W continuous)***

***- Assist modes: 5 levels + Walk assist***

***- Safety: Brake cutoff <50 ms, thermal derate above 80 °C motor / 60 °C cells***



