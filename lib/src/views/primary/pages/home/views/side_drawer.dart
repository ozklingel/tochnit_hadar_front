import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/models/user/user.dto.dart';
import 'package:hadar_program/src/services/auth/auth_service.dart';
import 'package:hadar_program/src/services/routing/go_router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({
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
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.grey.shade200,
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/exit.png'),
                  ),
                ),
                onTap: () => const HomeRouteData().go(context),
              ),
            ],
          ),
          DrawerHeader(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: profileimage,
                ),
                const Text(
                  'John Doe',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('John@Doe', style: TextStyle(fontSize: 11)),
                TextButton(
                  child: Text(
                    "עריכת פרופיל",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  onPressed: () {
                    const UserProfileRouteData().push(context);
                  },
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                dense: true,
                leading: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(FluentIcons.data_pie_24_regular),
                ),
                title: const Text('מדדי תוכנית'),
                onTap: () => const SupportRouteData().go(context),
              ),
              ListTile(
                dense: true,
                leading: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(FluentIcons.map_24_regular),
                ),
                title: const Text('מפת מיקומים'),
                onTap: () => const SupportRouteData().go(context),
              ),
              if (user.role == Role.melave) ...[
                ListTile(
                  dense: true,
                  leading: const CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/images/envalop.png'),
                  ),
                  title: const Text('הודעות מערכת'),
                  onTap: () => const SupportRouteData().go(context),
                ),
                ListTile(
                  dense: true,
                  leading: const CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/images/call.png'),
                  ),
                  title: const Text('פניות שירות'),
                  onTap: () => const SupportRouteData().go(context),
                ),
              ] else if (user.role == Role.ahraiTohnit) ...[
                ListTile(
                  dense: true,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(FluentIcons.person_24_regular),
                  ),
                  title: const Text('ניהול משתמשים'),
                  onTap: () => const SupportRouteData().go(context),
                ),
                ListTile(
                  dense: true,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(FluentIcons.book_open_24_regular),
                  ),
                  title: const Text('מוסדות לימוד'),
                  onTap: () => const InstitutionsRouteData().push(context),
                ),
              ],
              ListTile(
                dense: true,
                leading: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(FluentIcons.settings_24_regular),
                ),
                title: const Text('הגדרות והתראות'),
                onTap: () => const SupportRouteData().go(context),
              ),
              ListTile(
                dense: true,
                leading: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(FluentIcons.arrow_exit_20_regular),
                ),
                title: const Text('התנתקות'),
                onTap: () => const SupportRouteData().go(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
