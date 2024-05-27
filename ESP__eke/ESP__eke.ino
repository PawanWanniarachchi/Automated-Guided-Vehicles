#include "HX711.h"

const int DOUT_PIN = 26; // DOUT pin of HX711 connected to GPIO 26
const int SCK_PIN = 27;  // SCK pin of HX711 connected to GPIO 27
int ledL = 2;

// Initialize the HX711 library
HX711 scale;

int inputPin = 32; 
int ledOF = 33;
int ledOB = 25;

const int trigPinOF = 22;
const int echoPinOF = 23;

const int trigPinOB = 18;
const int echoPinOB = 19;

float durationOF, distanceOF;
float durationOB, distanceOB;

void setup() {
  pinMode(ledL, OUTPUT);
  pinMode(inputPin, INPUT);
  pinMode(ledOF, OUTPUT);
  pinMode(ledOB, OUTPUT);
  pinMode(trigPinOF, OUTPUT);
  pinMode(echoPinOF, INPUT);
  pinMode(trigPinOB, OUTPUT);
  pinMode(echoPinOB, INPUT);
  Serial.begin(9600);

  // Initialize the scale with DOUT and SCK pins
  scale.begin(DOUT_PIN, SCK_PIN);
  scale.set_scale(); // Calibrate the scale
  scale.tare();      // Reset the scale to zero
}

void loop() {
  // Read the weight from the load cell
  float weight = scale.get_units(); // Get the weight in grams
  
  // Print the weight to the serial monitor
  Serial.print("Weight: ");
  Serial.print(weight);
  Serial.println(" g");

  if(weight > 100){
    digitalWrite(ledL, HIGH);
    delay(300);
  }else{
    digitalWrite(ledL,LOW);
    delay(300); // Wait for 1 second with the LED off
  }

  int inputVal = digitalRead(inputPin);
  
  if (inputVal == HIGH) {
    digitalWrite(trigPinOF, LOW);
    delay(2);
    digitalWrite(trigPinOF, HIGH);
    delay(10);
    digitalWrite(trigPinOF, LOW);
    
    durationOF = pulseIn(echoPinOF, HIGH);
    distanceOF = (durationOF * 0.0343) / 2;
    Serial.print("Distance 1: ");
    Serial.println(distanceOF);
    
    if (distanceOF < 15.00) {
      digitalWrite(ledOF, HIGH); 
    } else {
      digitalWrite(ledOF, LOW); 
    }
  } else {
    digitalWrite(trigPinOB, LOW);
    delay(2);
    digitalWrite(trigPinOB, HIGH);
    delay(10);
    digitalWrite(trigPinOB, LOW);
    
    durationOB = pulseIn(echoPinOB, HIGH);
    distanceOB = (durationOB * 0.0343) / 2;
    Serial.print("Distance 2: ");
    Serial.println(distanceOB);
    
    if (distanceOB < 15.00) {
      digitalWrite(ledOB, HIGH); 
    } else {
      digitalWrite(ledOB, LOW); 
    }
  }
}
