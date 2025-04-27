# Smart 4WD IoT Car with Dual Microcontroller Architecture

A multifunctional 4WD robotic car integrating **live video streaming**, **remote wireless control**, **environment monitoring**, and **radar-based obstacle detection**.  
Built using **ESP32-CAM** and **Arduino Nano**, connected via **Serial communication** for efficient multitasking.

---

## 📜 Table of Contents
- [Project Overview](#project-overview)
- [System Architecture](#system-architecture)
  - [ESP32-CAM (Main Controller)](#esp32-cam-main-controller)
  - [Arduino Nano (Sensor Management Unit)](#arduino-nano-sensor-management-unit)
- [Inter-MCU Communication](#inter-mcu-communication)
- [Advantages](#advantages)
- [Future Improvements](#future-improvements)

---

## 🛠️ Project Overview

This project uses a **dual-MCU** design where:

- The **ESP32-CAM** manages movement, web server control, and live video streaming.
- The **Arduino Nano** manages sensors for obstacle detection (radar) and environment monitoring (temperature, humidity, and gas detection).

This division allows smooth multitasking and higher reliability.

---

## 🏗️ System Architecture

### ESP32-CAM (Main Controller)
Responsible for all real-time control and networking functionalities:

- **Motor Driver Control:**  
  - Controls a 4WD chassis via **L298N Motor Driver**.
  - Supports forward, backward, left, right, and stop operations.

- **Wi-Fi Server Hosting:**  
  - Hosts a control web page accessible from any smartphone, PC, or tablet connected to the same Wi-Fi.
  - Provides movement controls and live camera feed.

- **Camera Streaming:**  
  - Live video feed from the onboard camera for remote navigation.

---

### Arduino Nano (Sensor Management Unit)
Handles all sensing tasks independently:

- **Ultrasonic Radar System:**
  - **HC-SR04** ultrasonic sensor mounted on a servo motor.
  - Sweeps 0°–180° to scan surroundings and detect obstacles.
  - Sends distance data periodically to the ESP32-CAM.

- **DHT11 Sensor (Environment Sensing):**
  - Measures **temperature** and **humidity**.
  - Useful for environmental analysis and smart monitoring.

- **MQ-7 Gas Sensor (Safety Monitoring):**
  - Detects **carbon monoxide (CO)** gas levels.
  - Enhances system safety with hazardous gas detection.

---

## 🔌 Inter-MCU Communication

- **Serial (UART) Communication:**  
  - Arduino Nano sends sensor data (radar, temperature, humidity, gas) over Serial to ESP32-CAM.
  - ESP32 parses incoming data and updates the dashboard accordingly.
  
This ensures tasks are distributed efficiently without overwhelming a single microcontroller.

---

## 💡 Advantages

- **Load Balancing:**  
  Efficient distribution of tasks between ESP32-CAM and Arduino Nano.

- **Real-Time Performance:**  
  Smooth motor control, uninterrupted video streaming, and continuous environment scanning.

- **Modularity:**  
  Easy hardware upgrades or troubleshooting without affecting other parts of the system.

- **Scalability:**  
  Future sensors or features can be easily added to the Nano without straining the ESP32-CAM.

---

## 🚀 Future Improvements

- Implement **AI-based object recognition** using ESP32’s processing capability.
- Add **data logging** to SD card or send data to the cloud.
- Integrate **battery level monitoring** and **auto-return** when the battery is low.
- Enhance radar visualization with a **real-time radar UI** on the web server.

---
