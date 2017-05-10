#include <Servo.h>
 
Servo esc1;
Servo esc2;
int throttle=1500;
int mappedThrottle=map(1500, 0, 1023, 1000, 2000);
int input=0;

void setup() {
  esc1.attach(9);
  esc2.attach(10);
  Serial.begin(9600);
}

// Serial.println("Input a throttle value from 0 to 100");
void loop() {
  // send data only when you receive data:
//  while (Serial.available() > 0) {
//          // read the incoming byte:
//          throttle = Serial.parseInt(); // += Serial.read();
//
//          // say what you got:
//          Serial.print("New input received: ");
//          Serial.println(throttle);
//          Serial.println("Input a throttle value from -100 to 100");
//        }
  switch (1){
    case 1:
      input = analogRead(2);
      Serial.print("Pot input: ");
      Serial.println(input);
      mappedThrottle = map(input, 0, 1023, 1000, 2000);
      esc1.writeMicroseconds(mappedThrottle);
      esc2.writeMicroseconds(mappedThrottle);
      delay(250);
      break;
    case 2:
      input = 712; // Neutral
      Serial.print("Pot input: "); Serial.println(input);
      mappedThrottle = map(input, 0, 1023, 1000, 2000);
      esc1.writeMicroseconds(mappedThrottle);
      esc2.writeMicroseconds(mappedThrottle);
      delay(1000);
      
      input = 560; // Forward speed
      Serial.print("Pot input: "); Serial.println(input);
      mappedThrottle = map(input, 0, 1023, 1000, 2000);
      esc1.writeMicroseconds(mappedThrottle);
      esc2.writeMicroseconds(mappedThrottle);
      delay(1000);
      
      input = 228; // Brake
      Serial.print("Pot input: "); Serial.println(input);
      mappedThrottle = map(input, 0, 1023, 1000, 2000);
      esc1.writeMicroseconds(mappedThrottle);
      esc2.writeMicroseconds(mappedThrottle);
      delay(250);
      
      input = 478; // Neutral
      Serial.print("Pot input: "); Serial.println(input);
      mappedThrottle = map(input, 0, 1023, 1000, 2000);
      esc1.writeMicroseconds(mappedThrottle);
      esc2.writeMicroseconds(mappedThrottle);
      delay(250);
      
      input = 312; // Reverse speed
      Serial.print("Pot input: ");
      Serial.println(input);
      mappedThrottle = map(input, 0, 1023, 1000, 2000);
      esc1.writeMicroseconds(mappedThrottle);
      esc2.writeMicroseconds(mappedThrottle);
      delay(2000);
      
      break;
  }
}
