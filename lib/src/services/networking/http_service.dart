import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const _chatBoxUrl = '${Consts.baseUrl}messegaes_form/add';
  static const _getNoriUrl = '${Consts.baseUrl}notification_form/getAll';
  static const _getUserDetailUrl =
      '${Consts.baseUrl}userProfile_form/getProfileAtributes';
  static final _setUserImageUrl = Uri.parse(
    '${Consts.baseUrl}userProfile_form/uploadPhoto',
  );
  static const _setUserDetailUrl =
      '${Consts.baseUrl}setEntityDetails_form/setByType';
  static final _sendAllreadyreadUrl = Uri.parse(
    '${Consts.baseUrl}notification_form/setWasRead',
  );
  static final _setSettingUrl = Uri.parse(
    '${Consts.baseUrl}notification_form/setSetting',
  );
  static const _getNotifSettingUrl =
      '${Consts.baseUrl}notification_form/getAllSetting';
  static const token = "11"; //await Candidate().getToken();
  static final httpClient = HttpClient();

  static getUserNotiSetting(userid) async {
    userid = "972523301800";
    final response = await http.get(
      Uri.parse("$_getNotifSettingUrl?userId=$userid"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  static Future<Future<ui.Image>> downloadFile(
    String url,
    String filename,
  ) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    // print(bytes);
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
    // print(userid);
    print("$_getNoriUrl?userId=" + userid);
    final response = await http.get(
      Uri.parse("$_getNoriUrl?userId=$userid"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  static setSetting(
    userId,
    bool notifyStartWeek,
    bool notifyDayBefore,
    bool notifyMorning,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      _setSettingUrl,
    );
    // print(_setSettingUrl);
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.fields['userId'] = userId;
    request.fields['notifyMorning'] = (!notifyMorning).toString();
    request.fields['notifyDayBefore'] = (!notifyDayBefore).toString();
    request.fields['notifyStartWeek'] = (!notifyStartWeek).toString();
    // print(notifyStartWeek);
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

    // print("request image: " + request.toString());

    // var res = await request.send();

    // http.Response response = await http.Response.fromStream(res);
  }

  static sendAllreadyread(notiId) async {
    print(_sendAllreadyreadUrl);
    var request = http.MultipartRequest(
      'POST',
      _sendAllreadyreadUrl,
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    // print(notiId);
    request.fields['noti_id'] = notiId;

    request.headers.addAll(headers);
    // print(request);
    var res = await request.send();
    return res;
  }

  static Future<http.Response> getUserDetail(userid) async {
    // print(userid);
    print("$_getUserDetailUrl?userId=$userid");
    final response = await http.get(
      Uri.parse("$_getUserDetailUrl?userId=$userid"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print('Token : ${token}');
    return response;
  }

  static setUserDetail(typeOfSet, entityId, atrrToBeSet) async {
    // print(atrrToBeSet);
    // print(entityId);
    // print(typeOfSet);

    var atrrToBeSetString = "{";
    for (var age in atrrToBeSet) {
      var agesplited = age.split("-");
      if (agesplited[0] != null && agesplited[0] != "") {
        atrrToBeSetString += "${"${"\"$agesplited[1]"}\":\"$agesplited[0]"}\",";
      }
    }
    atrrToBeSetString =
        atrrToBeSetString.substring(0, atrrToBeSetString.length - 1);
    atrrToBeSetString += "}";
    // print(atrrToBeSetString);
    Map<String, dynamic> request = {
      "typeOfSet": typeOfSet,
      "entityId": entityId,
      "atrrToBeSet": atrrToBeSetString,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.put(
      Uri.parse(_setUserDetailUrl),
      headers: headers,
      body: json.encode(request),
    );
    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }

  static chatBoxUrl(subject, contant, context) async {
    Map<String, dynamic> request = {
      "content": contant,
      "subject": subject,
      "created_by_id": "972523301800",
      "created_for_id": "972523301800",
      "attachments": "",
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse(_chatBoxUrl),
      headers: headers,
      body: json.encode(request),
    );
    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }
}
