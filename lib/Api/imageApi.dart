import 'dart:convert';

import 'package:flutter_open_ai/constant/ApiKey.dart';
import 'package:http/http.dart' as http;

var apikey = ApiKey.apiKey;

class ImageApi {
  static final uri = Uri.parse('https://api.openai.com/v1/images/generations');

  static generateImage(String txt, String size) async {
    var res = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $apikey'
      },
      body: jsonEncode(
        {
          'prompt': txt,
          'n': 1,
          'size': size,
        },
      ),
    );
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return data['data'][0]['url'].toString();
    }
    print(data);
  }
}
