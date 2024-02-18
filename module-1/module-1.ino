#define TFT_PINK 0xFC18
#define WAIT 1000
#define SCREEN_WIDTH 128

#include <TFT_eSPI.h> // Graphics and font library for ST7735 driver chip
#include <SPI.h>

TFT_eSPI tft = TFT_eSPI();  // Invoke library, pins defined in User_Setup.h

const char* messages[] = {"I may think in binary, but you're the only 1", "I must be an exception because you sure caught me", "Are you https?? Because without you I'm just ://", 
"Are you a function? Let me call you.", "Are you CSS? Cause you got class and style", "Are you double? You always float inside my head", "With all the variables in my life, you can be the constant"};

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  tft.init();
  tft.setRotation(1);
}

void loop() {
  // put your main code here, to run repeatedly:
  tft.setTextSize(1);
  tft.fillScreen(TFT_PINK);
  tft.setTextColor(TFT_BLUE, TFT_PINK);
  tft.drawString("HAPPY V<3LENTINE'S", 0, 52, 4);
  tft.drawString("DAY", 95, 80, 4);
  delay(WAIT);

  const char* randomMessage = messages[rand() % (sizeof(messages) / sizeof(messages[0]))];
  Serial.println("RANDOM MESSAGE");
  Serial.println(randomMessage);
  tft.fillScreen(TFT_BLUE);
  tft.setTextColor(TFT_PINK, TFT_BLUE);
  tft.setTextWrap(true);

  int charsLeft = strlen(randomMessage);
  int start = 0;
  int y = 52;
  
  while (charsLeft > 0) {
    Serial.println("ENTERING WHILE..");
    char messageSubstring[31]; // extra space for null terminator
    int substringLength = (charsLeft >= 30) ? 30 : charsLeft;
    strncpy(messageSubstring, randomMessage + start, substringLength);
    messageSubstring[substringLength] = '\0'; // null terminator
    charsLeft -= substringLength;
    start += substringLength;

    tft.drawString(messageSubstring, 5, y, 2);
    y += 20;
  }
  delay(2000);


  tft.fillScreen(TFT_PINK);
  tft.setTextColor(TFT_BLUE, TFT_PINK);
  tft.drawString("<3 <3 <3 <3 <3 <3 <3 <3", 0, 52, 4);
  delay(WAIT);
}
