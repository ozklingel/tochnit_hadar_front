import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static String _getUserDetailUrl =
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/userProfile_form/getProfileAtributes';
  static var _setUserImageUrl = Uri.parse(
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/userProfile_form/uploadPhoto');
  static final _setUserDetailUrl =
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/setEntityDetails_form/setByType';
  static final _ChatBoxUrl =
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/messegaes_form/add';
  static String _getNoriUrl =
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/notification_form/getAll';
  static var _sendAllreadyreadUrl = Uri.parse(
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/notification_form/setWasRead');
  static var _setSettingUrl = Uri.parse(
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/notification_form/setSetting');
  static String _getNoriSettingUrl =
      'http://ec2-13-53-126-125.eu-north-1.compute.amazonaws.com/notification_form/getAllSetting';
  static String token = "11"; //await Candidate().getToken();
  static var httpClient = new HttpClient();

  static getUserNotiSetting(userid) async {
    print(userid);
    print(_getNoriSettingUrl + "?userId=" + userid);
    final response = await http
        .get(Uri.parse(_getNoriSettingUrl + "?userId=" + userid), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return response;
  }

  static Future<Future<ui.Image>> downloadFile(
      String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    print(bytes);
    return bytesToImage(bytes);
  }

  static Future<ui.Image> bytesToImage(Uint8List imgBytes) async {
    ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
    ui.FrameInfo frame;
    try {
      frame = await codec.getNextFrame();
    } finally {
      codec.dispose();
    }
    return frame.image;
  }

  static getUserNoti(userid, context) async {
    print(userid);
    print(_getNoriUrl + "?userId=" + userid);
    final response =
        await http.get(Uri.parse(_getNoriUrl + "?userId=" + userid), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return response;
  }

  static setSetting(userId, bool notifyStartWeek, bool notifyDayBefore,
      bool notifyMorning) async {
    var request = http.MultipartRequest(
      'POST',
      _setSettingUrl,
    );
    print(_setSettingUrl);
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.fields['userId'] = userId;
    request.fields['notifyMorning'] = (!notifyMorning).toString();
    request.fields['notifyDayBefore'] = (!notifyDayBefore).toString();
    request.fields['notifyStartWeek'] = (!notifyStartWeek).toString();
    print(notifyStartWeek);
    request.headers.addAll(headers);

    var res = await request.send();
    return res;
  }

  static uploadPhoto(File selectedImage, userid) async {
    var request = http.MultipartRequest(
      'POST',
      _setUserImageUrl,
    );
    request.fields['userId'] = userid;

    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(),
        filename: selectedImage.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    print("request image: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
  }

  static sendAllreadyread(notiId) async {
    var request = http.MultipartRequest(
      'POST',
      _sendAllreadyreadUrl,
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    print(notiId);
    request.fields['noti_id'] = notiId;

    request.headers.addAll(headers);
    print(request);
    var res = await request.send();
    return res;
  }

  static Future<http.Response> getUserDetail(userid) async {
    print(userid);
    print(_getUserDetailUrl);
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

  /**
   * accepts two parameters,the endpoint and the file
   * returns Response from server
   */

  static ChatBoxUrl(subject, contant, context) async {
    Map<String, dynamic> request = {
      "content": contant,
      "subject": subject,
      "created_by_id": "+972549247616",
      "created_for_id": "+972549247616",
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(Uri.parse(_ChatBoxUrl),
        headers: headers, body: json.encode(request));
    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }
}
