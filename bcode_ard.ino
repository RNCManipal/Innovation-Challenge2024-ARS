#include <Arduino_LSM6DS3.h> // Include the IMU library

// Threshold values for accident detection
const float accelerationThreshold = 2.5; // g-force threshold (adjust as needed)
const float gyroscopeThreshold = 60.0;   // degrees per second threshold (adjust as needed)
bool accidentSent = false;               // Flag to ensure action is only done once per detection
bool waitingForCancel = false;           // Flag to track if waiting for cancel

unsigned long accidentTime = 0;          // Time when the accident is detected
const unsigned long cancelWaitTime = 10000; // 10 seconds in milliseconds

// Buzzer pin and alarm time
const int buzzerPin = 10;                 // Pin for the buzzer
const unsigned long buzzerAlarmTime = 7000; // 10 seconds in milliseconds

void setup() {
  // Start Serial communication for debugging
  Serial.begin(9600);

  // Start Serial1 for Bluetooth or SIM800L
  Serial1.begin(9600);

  // Initialize the IMU
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

  // Initialize the buzzer pin
  pinMode(buzzerPin, OUTPUT);
  digitalWrite(buzzerPin, LOW);  // Ensure the buzzer is off initially

  Serial.println("Nano 33 IoT initialized");
}

void loop() {
  float accelerationX, accelerationY, accelerationZ;
  float gyroscopeX, gyroscopeY, gyroscopeZ;

  // Read acceleration and gyroscope data
  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(accelerationX, accelerationY, accelerationZ);
  }
  if (IMU.gyroscopeAvailable()) {
    IMU.readGyroscope(gyroscopeX, gyroscopeY, gyroscopeZ);
  }

  // Calculate the magnitude of the acceleration vector
  float accelerationMagnitude = sqrt(accelerationX * accelerationX + accelerationY * accelerationY + accelerationZ * accelerationZ);

  // Check if any thresholds are exceeded and accident is not yet sent
  if ((accelerationMagnitude > accelerationThreshold || 
      abs(gyroscopeX) > gyroscopeThreshold || 
      abs(gyroscopeY) > gyroscopeThreshold  
      ) && !accidentSent && !waitingForCancel) {

    // Accident detected, send boolean 1 to app and start waiting for cancel request
    Serial.println("Accident detected. Sending 1 to app and waiting for cancel...");
    Serial1.println("1");  // Send boolean value 1 to the app
    waitingForCancel = true;
    accidentTime = millis();  // Record the time when the accident is detected

    // Trigger the buzzer for 10 seconds
    Serial.println("Buzzer alarm triggered...");
    digitalWrite(buzzerPin, HIGH); // Turn on the buzzer
  }

  // If waiting for cancel, check for cancel message or timeout
  if (waitingForCancel) {
    // Check for incoming cancellation message from the app
    if (Serial1.available()) {
      String receivedMessage = Serial1.readString();
      receivedMessage.trim(); // Remove any whitespace or newline characters
      if (receivedMessage == "cancel") {
        Serial.println("Cancellation received from app. SMS will not be sent.");
        digitalWrite(buzzerPin, LOW); // Turn off the buzzer immediately
        resetDetection(); // Reset flags after receiving cancellation
        return;            // Exit the loop to prevent SMS sending
      }
    }

    // Check if 10 seconds have passed without receiving a cancellation
    if (millis() - accidentTime >= cancelWaitTime) {
      // Time's up, send the SMS
      delay(1000);
      sendSMSToEmergencyContacts();
      digitalWrite(buzzerPin, LOW); // Turn off the buzzer after sending SMS
      resetDetection();  // Reset flags after sending SMS
    }
  }

  delay(100); // Small delay to reduce CPU load
}

// Function to send SMS to emergency contacts
void sendSMSToEmergencyContacts() {
  Serial.println("No cancel received. Sending SMS...");

  // Send AT commands to SIM800L to send SMS
  sendCommand("AT", 1000);        // Check communication
  sendCommand("AT+CMGF=1", 1000); // Set SMS mode to text mode
  sendCommand("AT+CMGS=\"+918291768439\"", 1000); // Replace with your phone number
  
  delay(1000); // Wait a bit before sending the message
  Serial1.print("Accident detected! Please check your email."); // SMS content
  delay(500); // Give SIM800L time to process the message
  Serial1.write(26);  // Send Ctrl+Z (ASCII code 26) to send the SMS
  
  Serial.println("SMS sent!");
}

// Function to send AT commands and display responses in the Serial Monitor
void sendCommand(const char* command, int timeout) {
  Serial1.println(command);  // Send the AT command to SIM800L
  delay(timeout);  // Wait for the module to respond

  // Forward the response from SIM800L to the Serial Monitor
  while (Serial1.available()) {
    Serial.write(Serial1.read());
  }
}

// Function to reset the detection flags
void resetDetection() {
  Serial.println("Resetting accident detection flags...");
  waitingForCancel = false;  // Stop waiting for cancel
  accidentSent = false;      // Reset the accident flag so future accidents can be detected
  digitalWrite(buzzerPin, LOW);  // Ensure the buzzer is off
}
