import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/models/notification/notification.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/controller/notifications_controller.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/views/widgets/notification_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationDetailsScreen extends HookConsumerWidget {
  const NotificationDetailsScreen({
    super.key,
    required this.messageId,
  });

  final String messageId;

  @override
  Widget build(BuildContext context, ref) {
    final message = ref.watch(
      notificationsControllerProvider.select(
        (val) {
          return val.value!.firstWhere(
            (element) => element.id == messageId,
            orElse: () => const NotificationDto(),
          );
        },
      ),
    );

    useEffect(
      () {
        
          ref
              .read(notificationsControllerProvider.notifier)
              .setToReadStatus(message);
        
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('פרטי התראה'),
        centerTitle: true,
      ),
      body:  Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 232,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                         Text(
                          message.description
                        ),
                   ],
                  ),
                ),
              
              ],
            ),
          ),
      
    
  
    );
  }
}
