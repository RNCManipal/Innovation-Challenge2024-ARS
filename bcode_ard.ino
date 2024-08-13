#include <Arduino_LSM6DS3.h> // Include the IMU library

// Threshold values for accident detection
const float accelerationThreshold = 2.5; // g-force threshold (adjust as needed)
const float gyroscopeThreshold = 60.0;  // degrees per second threshold (adjust as needed)
bool accidentSent = false; // Flag to ensure message is sent only once per detection

void setup() {
  // Start Serial communication for debugging
  Serial.begin(9600);

  // Start Serial1 for HC-05 communication (Serial1 uses pins D0 (RX) and D1 (TX) on Nano 33 IoT)
  Serial1.begin(9600);

  // Initialize the IMU
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

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

  // Check if any thresholds are exceeded
  if ((accelerationMagnitude > accelerationThreshold || 
      abs(gyroscopeX) > gyroscopeThreshold || 
      abs(gyroscopeY) > gyroscopeThreshold || 
      abs(gyroscopeZ) > gyroscopeThreshold) && !accidentSent) {
    
    // If the threshold is exceeded, send an accident detected message
    Serial1.println("Accident detected");
    Serial.println("Accident detected");
    accidentSent = true; // Set the flag to true to prevent continuous sending
  } else if (accelerationMagnitude <= accelerationThreshold && 
             abs(gyroscopeX) <= gyroscopeThreshold && 
             abs(gyroscopeY) <= gyroscopeThreshold && 
             abs(gyroscopeZ) <= gyroscopeThreshold) {
    // Reset the flag if conditions return to normal
    accidentSent = false;
  }

  delay(1000); // Small delay to reduce CPU load
}
