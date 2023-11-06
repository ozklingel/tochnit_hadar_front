import 'package:flutter/material.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/apprentice/apprentice.dto.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/views/widgets/notification_widget.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../models/notification/notification.dto.dart';
import '../../../../../services/notifications/toaster.dart';
import '../../../../../services/routing/go_router_provider.dart';
import '../controller/notifications_controller.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () => const HomeRouteData().go(context),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () => Toaster.unimplemented(),
          ),
          const SizedBox(width: 16),
        ],
        title: const Text('התראות'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => ref.refresh(notificationsControllerProvider.future),
        child: controller.unwrapPrevious().when(
              error: (error, s) => CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Center(
                      child: Text(error.toString()),
                    ),
                  ),
                ],
              ),
              loading: () => _ResultsBody(
                isLoading: true,
                messages: List.generate(
                  10,
                  (index) => const NotiDto(
                    title: 'titletitletitletitle',
                    content: 'contentcontentcontent',
                    dateTime: 0,
                    attachments: ['attachment'],
                    from: ApprenticeDto(
                      firstName: 'firstNamefirstName',
                      lastName: 'lastNamelastName',
                    ),
                  ),
                ),
              ),
              data: (messages) => _ResultsBody(
                isLoading: false,
                messages: messages,
              ),
            ),
      ),
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.messages,
    required this.isLoading,
  });

  final List<NotiDto> messages;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return EmptyState(
        image: Assets.images.noMessages.svg(),
        topText: 'אין הודעות נכנסות',
        bottomText: 'הודעות נכנסות שישלחו, יופיעו כאן',
      );
    }

    return ListView(
      children: messages
          .map(
            (e) => Skeletonizer(
              enabled: isLoading,
              child: notificationWidget.collapsed(
                notification: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
