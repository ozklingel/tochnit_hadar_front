import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const _chatBoxUrl = '${Consts.baseUrl}messegaes_form/add';
  // static const _getNoriUrl = '${Consts.baseUrl}notification_form/getAll';

  static final _addGiftCodeExcel = Uri.parse(
    '${Consts.baseUrl}gift/add_giftCode_excel',
  );

  static final _setSettingUrl = Uri.parse(
    '${Consts.baseUrl}notification_form/setSetting',
  );
  static final _setSettingMadadimUrl = Uri.parse(
    '${Consts.baseUrl}master_user/setSetting_madadim',
  );
  static const _getNotifSettingUrl =
      '${Consts.baseUrl}notification_form/getAllSetting';

  static const _getMadadimSettingUrl =
      '${Consts.baseUrl}master_user/getAllSetting_madadim';
  static const _getGifturl = '${Consts.baseUrl}gift/getGift';
  static const _getUsedGifturl = '${Consts.baseUrl}gift/getGifts_cnt';

  static const _deleteGifturl = '${Consts.baseUrl}gift/delete';
  static const _deleteGiftAllurl = '${Consts.baseUrl}gift/deleteAll';
  static const _exportAprenticesStatusUrl =
      '${Consts.baseUrl}export_import/lowScoreApprentice_tohnit';

  static const token = "11"; //await Candidate().getToken();
  static final httpClient = HttpClient();

  static Future<Future<ui.Image>> downloadFile(
    String url,
    String filename,
  ) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    return bytesToImage(bytes);
  }

  static exportApprenticeStatus(
    userId,
    String exportDate,
  ) async {
    return http.post(
      Uri.parse(_exportAprenticesStatusUrl.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        //'export_date': null,
      }),
    );
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

  static getUserAlert(userid) async {
    final response = await http.get(
      Uri.parse(
        "${Consts.baseUrl}notification_form/get_outbound?userId=$userid",
      ),
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
    return http.post(
      Uri.parse(_setSettingUrl.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'notifyStartWeek': notifyStartWeek.toString(),
        'notifyDayBefore': notifyDayBefore.toString(),
        'notifyMorning': notifyMorning.toString(),
      }),
    );
  }

  static setSettingMadadim1(
    userId,
    String fieldToChange,
    String value,
  ) async {
    return http.post(
      Uri.parse(_setSettingMadadimUrl.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'fieldToChange': value,
      }),
    );
  }

  static setSettingMadadim(
    userId,
    String fieldToChange,
    String value,
  ) async {
    Map<String, dynamic> request = {
      'userId': userId,
      fieldToChange: value,
    };
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse(_setSettingMadadimUrl.toString()),
      headers: headers,
      body: json.encode(request),
    );
    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }

  static addGiftCodeExcel(File selectedImage) async {
    var request = http.MultipartRequest(
      'put',
      _addGiftCodeExcel,
    );

    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.files.add(
      http.MultipartFile(
        'file',
        selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(),
        filename: selectedImage.path.split('/').last,
      ),
    );

    request.headers.addAll(headers);

    // ignore: unused_local_variable
    final res = await request.send();
    var response = await http.Response.fromStream(res);
    final result = jsonDecode(response.body) as Map<String, dynamic>;

    return result;
  }

  static chatBoxUrl(createdById, subject, contant, context) async {
    Map<String, dynamic> request = {
      "content": contant,
      "subject": subject,
      "created_by_id": createdById,
      "created_for_ids": [""],
      "attachments": [""],
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

  static getGift(userid, base, teudatZehut) async {
    final response = await http.get(
      Uri.parse(
        "$_getGifturl?userId=$userid?base=$base?teudat_zehut=$teudatZehut",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final u = jsonDecode(response.body);

    String t1 = (u["result"]) as String;

    return t1;
  }

  static deleteGift(apprentice, giftCode) async {
    Map<String, dynamic> request = {
      "giftCode": giftCode,
      "apprentice_id": apprentice,
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.put(
      Uri.parse(_deleteGifturl),
      headers: headers,
      body: json.encode(request),
    );

    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }

  static deleteGiftAll(userId) async {
    Map<String, dynamic> request = {
      "userId": userId,
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.put(
      Uri.parse(_deleteGiftAllurl),
      headers: headers,
      body: json.encode(request),
    );

    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }

  static getUserNotiSetting(userid) async {
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

  static getMadadimSetting(userid) async {
    final response = await http.get(
      Uri.parse("$_getMadadimSettingUrl?userId=$userid"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  static getUsedGifts(
    userid,
  ) async {
    final response = await http.get(
      Uri.parse(
        "$_getUsedGifturl?userId=$userid",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var u = jsonDecode(response.body);

    return u;
  }
}
