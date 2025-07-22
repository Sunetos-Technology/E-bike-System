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