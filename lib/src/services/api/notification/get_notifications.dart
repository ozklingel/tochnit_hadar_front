import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:hadar_program/src/services/networking/dio_service/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/notification/notification.dto.dart';

part 'get_notifications.g.dart';

@Riverpod(
  dependencies: [
    DioService,
  ],
)
class GetNotifications extends _$GetNotifications {
  @override
  FutureOr<List<NotificationDto>> build() async {
    final request =
        await ref.watch(dioServiceProvider).get(Consts.getAllNotifications);
    final parsed = (request.data as List<dynamic>)
        .map((e) => NotificationDto.fromJson(e))
        .toList();
    return parsed;
  }
}
