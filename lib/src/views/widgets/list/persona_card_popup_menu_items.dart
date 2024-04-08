import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/utils/functions/launch_url.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';

List<PopupMenuItem<dynamic>> personaCardPopupMenuItems({
  required BuildContext context,
  required PersonaDto persona,
}) {
  return [
    PopupMenuItem(
      child: const Text('להתקשר'),
      onTap: () => launchCall(phone: persona.phone),
    ),
    PopupMenuItem(
      child: const Text('שליחת וואטסאפ'),
      onTap: () => launchWhatsapp(phone: persona.phone),
    ),
    PopupMenuItem(
      child: const Text('שליחת SMS'),
      onTap: () => launchSms(phone: [persona.phone]),
    ),
    PopupMenuItem(
      child: const Text('דיווח'),
      onTap: () =>
          ReportNewRouteData(initRecipients: [persona.id]).push(context),
    ),
    PopupMenuItem(
      child: const Text('פרופיל אישי'),
      onTap: () => PersonaDetailsRouteData(id: persona.id).push(context),
    ),
  ];
}
