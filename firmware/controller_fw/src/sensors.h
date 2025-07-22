#pragma once
#include <Arduino.h>
struct SensorData {
float throttle; // 0.0â€“1.0
float cadence_hz;
bool brake_active;
};
void sensors_init();
SensorData sensors_read();