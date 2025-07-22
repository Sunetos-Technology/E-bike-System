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