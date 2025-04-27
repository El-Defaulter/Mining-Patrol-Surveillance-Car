#include <DHT.h>
#include <servo.h>

#define TRIG_PIN 2      // D2 on Nano board
#define ECHO_PIN 3      // D3 on Nano board
#define DHT_PIN 4       // D4 on Nano board
#define SERVO_PIN 5     // D5 on Nano board
#define MQ7_PIN A0      // MQ7 Gas sensor (Analog)

DHT dht(DHT_PIN, DHT11); // Initialize DHT sensor (DHT11 or DHT22)
Servo myServo;  // Create servo object for servo control

long duration;
int distance;
float temperature, humidity, gasLevel;

void setup() {
  Serial.begin(9600);  // Start serial communication at 9600 baud rate
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  dht.begin();
  myServo.attach(SERVO_PIN);
  
  // Initializing the Servo to default position
  myServo.write(90);  // Servo at 90 degrees
  delay(1000);
}

void loop() {
  // Read distance from ultrasonic sensor
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  duration = pulseIn(ECHO_PIN, HIGH);
  distance = duration * 0.0344 / 2; // Calculate distance in cm
  
  // Read temperature and humidity from DHT sensor
  temperature = dht.readTemperature();  // Get temperature in Celsius
  humidity = dht.readHumidity();       // Get humidity percentage
  
  // Read gas level from MQ7 sensor (the value is analog, between 0 to 1023)
  gasLevel = analogRead(MQ7_PIN);
  gasLevel = map(gasLevel, 0, 1023, 0, 100);  // Map to a 0-100 scale
  
  // Prepare the data in the format expected by Processing (angle,distance,temperature,humidity,gas_level)
  int angle = 0;  // You can set this angle from any other sensor or preset (e.g., servo angle)
  
  // Send the data in the format angle,distance,temperature,humidity,gas_level
  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(",");
  Serial.print(temperature);
  Serial.print(",");
  Serial.print(humidity);
  Serial.print(",");
  Serial.print(gasLevel);
  Serial.println(".");
  
  delay(200); // Delay to match Processing's serial read rate
}
