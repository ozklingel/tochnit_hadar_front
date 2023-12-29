import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/event/event.dto.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpcomingEventsWidget extends ConsumerWidget {
  const UpcomingEventsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    // final upcomingEvents =
    //     ref.watch(eventsControllerProvider).valueOrNull ?? [];

    final children = [
      const _EventCard(
        // event: apprentice.events.firstOrNull ?? const EventDto(),
        event: EventDto(),
      ),
      const _EventCard(
        // event: apprentice.events.firstOrNull ?? const EventDto(),
        event: EventDto(),
      ),
      const _EventCard(
        // event: apprentice.events.firstOrNull ?? const EventDto(),
        event: EventDto(),
      ),
    ];

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
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          ),
        ),
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
          onTap: () => GiftRouteData(id: event.id).go(context),
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
                        event.title,
                        style: TextStyles.s16w500cGrey2,
                      ),
                      Text(
                        event.description,
                        style: TextStyles.s14w300cGray2,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Icon(FluentIcons.gift_24_regular),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
