import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/gen/assets.gen.dart';
import 'package:hadar_program/src/models/notification/notification.dto.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/controller/notifications_controller.dart';
import 'package:hadar_program/src/views/primary/pages/notifications/views/widgets/notification_widget.dart';
import 'package:hadar_program/src/views/widgets/states/empty_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

//import '../../../../../models/message/message.dto.dart';
//import '../../messages/controller/messages_controller.dart';

class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);
    final msgsController = ref.watch(notificationsControllerProvider);
    // final isSearchOpen = useState(false);
    final searchController = useTextEditingController();

    useListenable(searchController);

    // Logger().d(msgsController.valueOrNull?.length);

    if (user.isLoading) {
      return const CircularProgressIndicator.adaptive();
    }

    switch (user.valueOrNull?.role) {
      case UserRole.melave:
      default:
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              SizedBox(width: 10,),
              
              GestureDetector(
                child: const Icon(
                  FluentIcons.more_vertical_24_regular,
                  color: Colors.black,
                ),
                onTap: () => const NotificationSettingRouteData().go(context),
              ),
            ],
            leading: GestureDetector(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () => const HomeRouteData().go(context),
            ),
            title: const Text(" התראות"),
          ),
          body: RefreshIndicator.adaptive(
            onRefresh: () =>
                ref.refresh(notificationsControllerProvider.future),
            child: msgsController.unwrapPrevious().when(
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
                  loading: () => _SearchResultsBody(
                    isLoading: true,
                    messages: List.generate(
                      10,
                      (index) => NotificationDto(
                        event: 'titletitletitletitle',
                        dateTime: DateTime.now().toIso8601String(),
                      ),
                    ),
                  ),
                  data: (messages) => _SearchResultsBody(
                    isLoading: false,
                    messages: messages
                        .where(
                          (element) =>
                              element.event
                                  .toLowerCase()
                                  .contains(searchController.text) ||
                              element.description
                                  .toLowerCase()
                                  .contains(searchController.text),
                        )
                        .toList(),
                  ),
                ),
          ),
        );
    }
  }
}

class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({
    required this.messages,
    required this.isLoading,
  });

  final List<NotificationDto> messages;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return EmptyState(
        image: Assets.images.noMessages.svg(),
        topText: 'אין  התראות',
        bottomText: 'התראות  שיוצרו, יופיעו כאן',
      );
    }

    return ListView(
      children: messages
          .map(
            (e) => Skeletonizer(
              enabled: isLoading,
              child: e.allreadyRead
                  ? NotificationWidget.expanded(
                      message: e,
                    )
                  : NotificationWidget.collapsed(
                      message: e,
                    ),
            ),
          )
          .toList(),
    );
  }
}
