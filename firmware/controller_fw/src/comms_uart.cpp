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