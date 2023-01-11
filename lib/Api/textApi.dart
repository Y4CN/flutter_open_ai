import 'dart:convert';

import 'package:flutter_open_ai/constant/ApiKey.dart';
import 'package:http/http.dart' as http;


Future<String> generateResponse(String userTxt) async {
  var url = Uri.https('api.openai.com', '/v1/completions');
  const apikey = ApiKey.apiKey;
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apikey'
    },
    body: jsonEncode(
      {
        'model': 'text-davinci-003',
        'prompt': userTxt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0
      },
    ),
  );

  print(response.body);
  //decode
  Map<String, dynamic> newResponse = jsonDecode(response.body);

  return newResponse['choices'][0]['text'];
}
