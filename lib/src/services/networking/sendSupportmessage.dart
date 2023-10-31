import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  static final _client = http.Client();

  static ChatBoxUrl(subject, contant, context) async {
    final _ChatBoxUrl = 'http://10.0.2.2:5000/messegaes_form/add';

    Map<String, dynamic> request = {
      "content": contant,
      "subject": subject,
      "created_by_id": "1",
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(Uri.parse(_ChatBoxUrl),
        headers: headers, body: json.encode(request));
    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }
}
