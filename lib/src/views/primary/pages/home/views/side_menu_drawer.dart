import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/enums/user_role.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/core/utils/extensions/string.dart';
import 'package:hadar_program/src/models/auth/auth.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/users_controller.dart';
import 'package:hadar_program/src/views/widgets/buttons/large_filled_rounded_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:requests_inspector/requests_inspector.dart';

import '../../../../../gen/assets.gen.dart';

class SideMenuDrawer extends ConsumerWidget {
  const SideMenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 260,
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
                      backgroundImage: CachedNetworkImageProvider(
                        auth.valueOrNull!.avatar,
                      ),
                    ),
                    Text(
                      auth.valueOrNull?.fullName.ifEmpty ?? '[NO NAME]',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      auth.valueOrNull?.email.ifEmpty ?? '[NO EMAIL]',
                      style: TextStyles.s14w400cGrey5,
                    ),
                    TextButton(
                      child: Text(
                        "פרופיל אישי ",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      onPressed: () =>
                          const UserProfileRouteData().push(context),
                    ),
                  ],
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
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
                    if ([UserRole.rakazEshkol, UserRole.rakazMosad]
                        .contains(auth.valueOrNull?.role)) {
                      ref.read(usersControllerProvider.notifier).mapView(true);
                    }
                    const PersonasRouteData().go(context);
                  },
                ),
                if ([UserRole.ahraiTohnit, UserRole.rakazEshkol]
                    .contains(auth.valueOrNull?.role)) ...[
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.person_24_regular),
                    title: const Text('ניהול משתמשים'),
                    onTap: () => const PersonasRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.book_open_24_regular),
                    title: const Text('מוסדות לימוד'),
                    onTap: () => const InstitutionsRouteData().push(context),
                  ),
                ],
                if (auth.valueOrNull?.role == UserRole.ahraiTohnit) ...[
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.gift_16_regular),
                    title: const Text('ניהול קודי מתנה'),
                    onTap: () => const GiftRouteData(id: "1").go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.settings_16_regular),
                    title: const Text('הגדרות מדדים'),
                    onTap: () => const ChartsSettingsRouteData().push(context),
                  ),
                ] else ...[
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.mail_12_regular),
                    title: const Text('פניות שירות'),
                    onTap: () => const SupportRouteData().push(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: Assets.illustrations.alarmBell.svg(),
                    title: const Text('התראות'),
                    onTap: () => const NotificationRouteData().go(context),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(FluentIcons.settings_16_regular),
                    title: const Text('הגדרות התראות'),
                    onTap: () =>
                        const NotificationSettingRouteData().push(context),
                  ),
                ],
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
            if (kDebugMode)
              ListTile(
                dense: true,
                leading: const Icon(FluentIcons.network_check_24_filled),
                title: const Text('HTTP INSPECTOR'),
                onTap: () async => InspectorController().showInspector(),
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
                    ref.read(authServiceProvider.notifier).logOff(),
                height: 46,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
