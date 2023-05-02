import 'package:http/http.dart' as http;

Future<void> sendCommand() async {
  const robotIP = "192.168.12.1"; // Replace with the robot's IP address
  const endpoint = "/command"; // Replace with the robot's API endpoint

  final response = await http.post(Uri.http(robotIP, endpoint),
      body: {"command": "move forward"}); // Replace with your command data

  if (response.statusCode == 200) {
    print("Command sent successfully");
  } else {
    print("Error sending command: ${response.statusCode}");
  }
}