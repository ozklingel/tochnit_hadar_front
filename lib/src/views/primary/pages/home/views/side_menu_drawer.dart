import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SideMenuDrawer extends ConsumerWidget {
  const SideMenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 250.0,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          (user.valueOrNull?.avatar.isEmpty ?? true)
                              ? null
                              : CachedNetworkImageProvider(
                                  user.valueOrNull!.avatar,
                                ),
                    ),
                    Text(
                      user.valueOrNull?.fullName ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.valueOrNull?.email ?? '',
                      style: const TextStyle(fontSize: 11),
                    ),
                    TextButton(
                      child: Text(
                        "פרופיל אישי ",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      onPressed: () {
                        const UserProfileRouteData().push(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                if (user.valueOrNull?.role == UserRole.melave) ...[
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.mail_24_regular),
                    title: const Text('הודעות מערכת'),
                    onTap: () => () => const MessagesRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.call_24_regular),
                    title: const Text('פניות שירות'),
                    onTap: () => const SupportRouteData().go(context),
                  ),
                ] else if (user.valueOrNull?.role == UserRole.ahraiTohnit) ...[
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.data_pie_24_regular),
                    title: const Text('מדדי תוכנית'),
                    onTap: () => const ChartsRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.map_24_regular),
                    title: const Text('מפת מיקומים'),
                    onTap: () {
                      const ApprenticesOrUsersRouteData().go(context);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.person_24_regular),
                    title: const Text('ניהול משתמשים'),
                    onTap: () =>
                        const ApprenticesOrUsersRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.book_open_24_regular),
                    title: const Text('מוסדות לימוד'),
                    onTap: () => const InstitutionsRouteData().push(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.book_open_24_regular),
                    title: const Text(' ניהול קודי מתנה'),
                    onTap: () => Toaster.unimplemented(),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.book_open_24_regular),
                    title: const Text('הגדרות מדדים'),
                    onTap: () => const ChartsRouteData().push(context),
                  ),
                ] else if (user.valueOrNull?.role == UserRole.rakazEshkol) ...[
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.data_pie_24_regular),
                    title: const Text('מדדי תוכנית'),
                    onTap: () => const ChartsRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.map_24_regular),
                    title: const Text('מפת מיקומים'),
                    onTap: () {
                      ref.read(usersControllerProvider.notifier).mapView(true);
                      const ApprenticesOrUsersRouteData().go(context);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.person_24_regular),
                    title: const Text('ניהול משתמשים'),
                    onTap: () =>
                        const ApprenticesOrUsersRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.book_open_24_regular),
                    title: const Text('מוסדות לימוד'),
                    onTap: () => const InstitutionsRouteData().push(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.book_open_24_regular),
                    title: const Text('פניות שירות'),
                    onTap: () => const SupportRouteData().push(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.book_open_24_regular),
                    title: const Text('   הגדרות התראות'),
                    onTap: () =>
                        const NotificationSettingRouteData().push(context),
                  ),
                ] else if (user.valueOrNull?.role == UserRole.rakazMosad) ...[
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.data_pie_24_regular),
                    title: const Text('מדדי תוכנית'),
                    onTap: () => const ChartsRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.map_24_regular),
                    title: const Text('מפת מיקומים'),
                    onTap: () {
                      ref.read(usersControllerProvider.notifier).mapView(true);
                      const ApprenticesOrUsersRouteData().go(context);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.person_24_regular),
                    title: const Text('פניות שירות '),
                    onTap: () => const SupportRouteData().go(context),
                  ),
                ],
                ListTile(
                  dense: true,
                  leading: const Icon(FluentIcons.settings_24_regular),
                  title: const Text('הגדרות והתראות'),
                  onTap: () => const NotificationSettingRouteData().go(context),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.notifications_none),
                  title: const Text(' התראות'),
                  onTap: () => const NotificationRouteData().go(context),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(FluentIcons.arrow_exit_20_regular),
                  title: const Text('התנתקות'),
                  onTap: () async => await showDialog(
                    context: context,
                    builder: (context) => const _ConfirmSignoutDialog(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmSignoutDialog extends ConsumerWidget {
  const _ConfirmSignoutDialog();

  @override
  Widget build(BuildContext context, ref) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: SizedBox(
        height: 340,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: CloseButton(),
              ),
              const Text(
                'התנתקות',
                style: TextStyles.s24w400,
              ),
              const Text(
                'האם אתה בטוח שברצונך להתנתק מהמערכת?',
                style: TextStyles.s16w400cGrey3,
              ),
              const SizedBox(height: 12),
              LargeFilledRoundedButton(
                label: 'הישאר מחובר',
                onPressed: () => Navigator.of(context).pop(),
                height: 46,
              ),
              LargeFilledRoundedButton.cancel(
                label: 'התנתק',
                onPressed: () =>
                    ref.read(userServiceProvider.notifier).logOff(),
                height: 46,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
