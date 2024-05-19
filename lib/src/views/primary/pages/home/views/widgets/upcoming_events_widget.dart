import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/datetime.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hadar_program/src/views/primary/pages/home/controllers/events_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpcomingEventsWidget extends ConsumerWidget {
  const UpcomingEventsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final upcomingEvents =
        (ref.watch(eventsControllerProvider).valueOrNull?.take(99).toList() ??
                [])
            .where((event) => event.isDateRelevant)
            .toList();

    if (upcomingEvents.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'אירועים קרובים',
            style: TextStyles.s20w500,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemCount: upcomingEvents.length,
            itemBuilder: (context, index) =>
                _EventCard(event: upcomingEvents[index]),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _EventCard extends ConsumerWidget {
  const _EventCard({
    required this.event,
  });

  final EventDto event;

  @override
  Widget build(BuildContext context, ref) {
    final eventDateTime = event.datetime.asDateTime;
    final persona = ref
        .watch(personasControllerProvider)
        .valueOrNull
        ?.firstWhereOrNull((element) => event.id.contains(element.id));
    return SizedBox(
      width: 232,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0x33ECF2F5),
              Color(0x333D94D2),
            ],
          ),
        ),
        child: InkWell(
          onTap: event.isBirthday
              ? () {
                  if (event.id.isEmpty) {
                    Toaster.error('missing gift id');
                    return;
                  }
                  GiftRouteData(id: event.id).go(context);
                }
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        persona?.fullName ?? event.title,
                        style: TextStyles.s16w500cGrey2,
                      ),
                      const Spacer(),
                      Text(
                        '${eventDateTime.asTimeAgoDayCutoff} בתאריך ${eventDateTime.he}\n${event.description}',
                        style: TextStyles.s14w300cGray2,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (event.isBirthday)
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      FluentIcons.gift_24_regular,
                      color: AppColors.blue02,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
