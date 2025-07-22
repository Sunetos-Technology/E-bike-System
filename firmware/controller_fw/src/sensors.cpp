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