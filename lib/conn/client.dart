import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> sendCommand(String command) async {
    print('Sending command...');
    var url = Uri.parse('http://192.168.123.15:5000/command');

    // var response = await http.get(url);
    var response = await http.post(url,
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{'command': command})
    );
    if (response.statusCode == 200) {
      print('Command sent successfully!');
    }
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.body;
      
}