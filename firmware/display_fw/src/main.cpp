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