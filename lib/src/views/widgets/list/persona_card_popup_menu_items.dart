import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';

class PersonaCardPopupMoreVerticalWidget extends StatelessWidget {
  const PersonaCardPopupMoreVerticalWidget({
    super.key,
    required this.personas,
    this.offset = const Offset(0, 40),
    this.surfaceTintColor,
    this.showCall = true,
    this.showMsg = true,
  });

  final List<PersonaDto> personas;
  final Offset offset;
  final Color? surfaceTintColor;
  final bool showCall;
  final bool showMsg;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        FluentIcons.more_vertical_24_regular,
      ),
      offset: const Offset(0, 40),
      surfaceTintColor: surfaceTintColor,
      itemBuilder: (context) => [
        if (showCall)
          PopupMenuItem(
            child: const Text('להתקשר'),
            onTap: () => launchCall(phone: personas.first.phone),
          ),
        PopupMenuItem(
          child: const Text('שליחת SMS'),
          onTap: () => launchSms(phone: personas.map((e) => e.phone).toList()),
        ),
        PopupMenuItem(
          child: const Text('שליחת וואטסאפ'),
          onTap: () => personas.length > 1
              ? Toaster.backend()
              : launchWhatsapp(phone: personas.first.phone),
        ),
        if (showMsg)
          PopupMenuItem(
            child: const Text('שליחת הודעה'),
            onTap: () => NewMessageRouteData(
              initRecpients: personas.map((e) => e.id).toList(),
            ).push(context),
          ),
        PopupMenuItem(
          child: const Text('דיווח'),
          onTap: () => ReportNewRouteData(
            initRecipients: personas.map((e) => e.id).toList(),
          ).push(context),
        ),
        if (personas.length == 1)
          PopupMenuItem(
            child: const Text('פרופיל אישי'),
            onTap: () =>
                PersonaDetailsRouteData(id: personas.first.id).push(context),
          ),
      ],
    );
  }
}
