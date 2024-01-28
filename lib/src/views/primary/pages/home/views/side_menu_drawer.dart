import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/user_service.dart';
import 'package:hadar_program/src/services/notifications/toaster.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SideMenuDrawer extends ConsumerWidget {
  const SideMenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userServiceProvider);

    const profileimage = NetworkImage(
      "https://th01-s3.s3.eu-north-1.amazonaws.com/638a1e29dc924e25ba6096f5c93583ca.jpg",
    );

    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 210.0,
            child: DrawerHeader(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: profileimage,
                  ),
                  Text(
                    user.valueOrNull!.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.valueOrNull!.email,
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
                onTap: () => Toaster.unimplemented(),
              ),
              if (user.valueOrNull?.role == UserRole.melave) ...[
                ListTile(
                  dense: true,
                  leading: const Icon(FluentIcons.mail_24_regular),
                  title: const Text('הודעות מערכת'),
                  onTap: () => Toaster.unimplemented(),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(FluentIcons.call_24_regular),
                  title: const Text('פניות שירות'),
                  onTap: () => Toaster.unimplemented(),
                ),
              ] else if (user.valueOrNull?.role == UserRole.ahraiTohnit) ...[
                ListTile(
                  dense: true,
                  leading: const Icon(FluentIcons.person_24_regular),
                  title: const Text('ניהול משתמשים'),
                  onTap: () => Toaster.unimplemented(),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(FluentIcons.book_open_24_regular),
                  title: const Text('מוסדות לימוד'),
                  onTap: () => const InstitutionsRouteData().push(context),
                ),
              ],
              ListTile(
                dense: true,
                leading: const Icon(FluentIcons.settings_24_regular),
                title: const Text('הגדרות והתראות'),
                onTap: () => const SupportRouteData().go(context),
              ),
              ListTile(
                dense: true,
                leading: const Icon(FluentIcons.arrow_exit_20_regular),
                title: const Text('התנתקות'),
                onTap: () => ref.read(userServiceProvider.notifier).logOff(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
