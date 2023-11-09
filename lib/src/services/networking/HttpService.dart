import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  static String _getUserDetailUrl =
      'http://10.0.2.2:5000/userProfile_form/getProfileAtributes';
  static var _setUserImageUrl =
      Uri.parse('http://10.0.2.2:5000/userProfile_form/uploadPhoto');
  static final _setUserDetailUrl =
      'http://10.0.2.2:5000/setEntityDetails_form/setByType';
  static final _ChatBoxUrl = 'http://10.0.2.2:5000/messegaes_form/add';
  static String _getNoriUrl = 'http://10.0.2.2:5000/notification_form/getAll';
  static var _sendAllreadyreadUrl =
      Uri.parse('http://10.0.2.2:5000/notification_form/setWasRead');
  static String token = "11"; //await Candidate().getToken();

  static getUserNoti(userid, context) async {
    final response =
        await http.get(Uri.parse(_getNoriUrl + "?userId=" + userid), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return response;
  }

  static sendAllreadyread(notiId) async {
    var request = http.MultipartRequest(
      'POST',
      _sendAllreadyreadUrl,
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.fields['noti_id'] = notiId;

    request.headers.addAll(headers);
    var res = await request.send();
    return res;
  }

  static Future<http.Response> getUserDetail(userid) async {
    final response = await http
        .get(Uri.parse(_getUserDetailUrl + "?userId=" + userid), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('Token : ${token}');
    return response;
  }

  static setUserDetail(typeOfSet, entityId, atrrToBeSet) async {
    print(atrrToBeSet);
    print(entityId);
    print(typeOfSet);

    var atrrToBeSetString = "{";
    for (var age in atrrToBeSet) {
      var agesplited = age.split("-");
      if (agesplited[0] != null && agesplited[0] != "")
        atrrToBeSetString +=
            "\"" + agesplited[1] + "\":" + "\"" + agesplited[0] + "\",";
    }
    atrrToBeSetString =
        atrrToBeSetString.substring(0, atrrToBeSetString.length - 1);
    atrrToBeSetString += "}";
    print(atrrToBeSetString);
    Map<String, dynamic> request = {
      "typeOfSet": typeOfSet,
      "entityId": entityId,
      "atrrToBeSet": atrrToBeSetString,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.put(Uri.parse(_setUserDetailUrl),
        headers: headers, body: json.encode(request));
    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }

  static Future<String> uploadPhotos(List<String> paths) async {
    Uri uri = _setUserImageUrl;
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    for (String path in paths) {
      print(path);
      request.files.add(await http.MultipartFile.fromPath('file', path));
    }
    print(request.toString());
    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);
    print('\n\n');
    print('RESPONSE WITH HTTP');
    print(responseString);
    print('\n\n');
    return responseString;
  }

  static ChatBoxUrl(subject, contant, context) async {
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
