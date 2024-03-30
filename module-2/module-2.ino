#include <TFT_eSPI.h> // Graphics and font library for ST7735 driver chip
#include <SPI.h>
#define WAIT 100
#define PIN_ANALOG_IN 26

TFT_eSPI tft = TFT_eSPI();  // Invoke library, pins defined in User_Setup.h
const int buttonPin = 33; // button is connected to pin 39

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  tft.init();
  tft.setRotation(1);

  pinMode(buttonPin, INPUT_PULLUP); // initalize button pin as input

}

void loop() {
  tft.setTextSize(1);
  tft.fillScreen(TFT_PINK);
  tft.setTextColor(TFT_BLUE, TFT_PINK);
  tft.drawString("Press the button", 30, 52, 4);
  tft.drawString("to jump", 70, 80, 4);

  int buttonVal = digitalRead(buttonPin);

  int adcVal = analogRead(PIN_ANALOG_IN);
  int dacVal = map(adcVal, 0, 4095, 0, 255);
  double voltage = adcVal / 4095.0 * 3.3;
  dacWrite(DAC1, dacVal);
  Serial.printf("Button: %d, ADC Val: %d, \t DAC Val: %d, \t Voltage: %.2f \n", buttonVal, adcVal, dacVal, voltage);
  delay(WAIT);
}
