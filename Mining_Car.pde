import processing.serial.*;

Serial myPort;
String data = "";
String angle = "";
String distance = "";
String temperature = "";
String humidity = "";
String gas = "";
int iAngle, iDistance;
float iTemp, iHumidity, iGas;

void setup() {
  size(1200, 700);
  smooth();
  myPort = new Serial(this, "com8", 9600);  // Adjust the port as needed
  myPort.clear();  // Clear the serial buffer at the start
}

void draw() {
  fill(98, 245, 31);
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height - height * 0.065);

  fill(98, 245, 31);
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) {
  // Read the incoming data
  String incomingData = myPort.readString();
  
  if (incomingData != null) {
    data += incomingData;  // Append the data received from Arduino
    int endIndex = data.indexOf('\n');  // Check for new line, indicating end of one data set
    if (endIndex != -1) {
      // Extract the complete data string up to the newline
      String completeData = data.substring(0, endIndex);
      data = data.substring(endIndex + 1);  // Remove the processed data from the buffer

      // Process the complete data string
      parseData(completeData);
    }
  }
}

void parseData(String completeData) {
  // Split the incoming data by '|' separator
  String[] dataArray = split(completeData, '|');
  
  if (dataArray.length >= 5) {
    // Extract each sensor value from the array
    angle = extractValue(dataArray[0], "Angle:");
    distance = extractValue(dataArray[1], "Distance:");
    temperature = extractValue(dataArray[2], "Temp:");
    humidity = extractValue(dataArray[3], "Humidity:");
    gas = extractValue(dataArray[4], "Gas Level:");

    // Convert the data to appropriate types
    iAngle = int(angle);
    iDistance = int(distance);
    iTemp = float(temperature);
    iHumidity = float(humidity);
    iGas = float(gas);
  } else {
    println("Data not in expected format: " + completeData);  // Debugging
  }
}

String extractValue(String dataString, String label) {
  int labelIndex = dataString.indexOf(label);
  if (labelIndex != -1) {
    String value = dataString.substring(labelIndex + label.length()).trim();
    return value.split(" ")[0];  // Get value before the unit (e.g., cm, °C, %)
  }
  return "0";  // Default value if not found
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);
  line(-width / 2, 0, width / 2, 0);
  for (int a = 30; a < 180; a += 30) {
    line(0, 0, (-width / 2) * cos(radians(a)), (-width / 2) * sin(radians(a)));
  }
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(9);
  stroke(255, 10, 10);
  float pixsDistance = iDistance * ((height - height * 0.1666) * 0.025);
  if (iDistance < 40) {
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),
         (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074);
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  pushMatrix();
  String noObject = (iDistance > 40) ? "Out of Range" : "In Range";

  fill(0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);

  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);
  textSize(40);
  text("Quantum Bits Lab", width - width * 0.875, height - height * 0.0277);
  text("Angle: " + iAngle, width - width * 0.48, height - height * 0.0277);
  text("Distance: ", width - width * 0.26, height - height * 0.0277);
  if (iDistance < 40) {
    text("        " + iDistance + " cm", width - width * 0.225, height - height * 0.0277);
  }

  // New sensor readings
  textSize(30);
  text("Temp: " + nf(iTemp, 0, 1) + "°C", 20, 40);
  text("Humidity: " + nf(iHumidity, 0, 1) + "%", 20, 80);
  text("Gas: " + nf(iGas, 0, 2), 20, 120);

  textSize(25);
  fill(98, 245, 60);
  String[] angles = { "30", "60", "90", "120", "150" };
  int[] degrees = { 30, 60, 90, 120, 150 };
  for (int i = 0; i < angles.length; i++) {
    resetMatrix();
    translate((width - width * 0.5) + width / 2 * cos(radians(degrees[i])), (height - height * 0.09) - width / 2 * sin(radians(degrees[i])));
    rotate(radians(degrees[i] - 90));
    text(angles[i], 0, 0);
  }
  popMatrix();
}
