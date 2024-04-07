import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkUtils {
  // get response
  static Future<dynamic> getMethod(String url) async {
    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      // print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("something went wrong");
      }
    } catch (e) {
      print('$e');
    }
  }
}
