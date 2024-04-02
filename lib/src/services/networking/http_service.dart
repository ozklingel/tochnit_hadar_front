import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpService {
  static const _chatBoxUrl = '${Consts.baseUrl}messegaes_form/add';
  // static const _getNoriUrl = '${Consts.baseUrl}notification_form/getAll';

  static final _add_giftCode_excel = Uri.parse(
    '${Consts.baseUrl}export_import/add_giftCode_excel',
  );


  static final _setSettingUrl = Uri.parse(
    '${Consts.baseUrl}notification_form/setSetting',
  );
  static const _getNotifSettingUrl =
      '${Consts.baseUrl}notification_form/getAllSetting';
  static const _getGifturl =
      '${Consts.baseUrl}gift/getGift';
  static const _deleteGifturl = '${Consts.baseUrl}gift/delete';
  static const _deleteGiftAllurl = '${Consts.baseUrl}gift/deleteAll';

  static const token = "11"; //await Candidate().getToken();
  static final httpClient = HttpClient();

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



  static getUserAlert(userid) async {
    final response = await http.get(
      Uri.parse("${Consts.baseUrl}notification_form/get_outbound?userId=$userid"),
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

  static add_giftCode_excel(File selectedImage) async {

    var request = http.MultipartRequest(
      'put',
      _add_giftCode_excel,
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

  return result['result'];
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
    Logger().d(responsePayload.toString());
    return responsePayload['result'];
  }

  static getGift(userid,base,teudat_zehut) async {
    final response = await http.get(
      Uri.parse("$_getGifturl?userId=$userid?base=$base?teudat_zehut=$teudat_zehut"),
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

    static delete_gift(apprentice,giftCode) async {
    Map<String, dynamic> request = {
      "giftCode": giftCode,
      "apprentice_id": apprentice
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.put(
      Uri.parse(_deleteGifturl),
      headers: headers,
      body: json.encode(request),
    );
        Logger().d(response.body);

    Map<String, dynamic> responsePayload = json.decode(response.body);
    return responsePayload['result'];
  }

      static delete_gift_all(userId) async {
    Map<String, dynamic> request = {
      "userId": userId,
    };

    final headers = {'Content-Type': 'application/json'};
    final response = await http.put(
      Uri.parse(_deleteGiftAllurl),
      headers: headers,
      body: json.encode(request),
    );
        Logger().d(response.body);

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
}
