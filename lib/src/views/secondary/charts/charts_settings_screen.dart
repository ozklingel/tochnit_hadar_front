import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/web.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/networking/http_service.dart';

class ChartsSettingsScreen extends StatefulHookConsumerWidget {
  const ChartsSettingsScreen({Key? key}) : super(key: key);
   @override
  ConsumerState<ChartsSettingsScreen> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<ChartsSettingsScreen> {
  String tochnitMeet_madad_date = '1999-01-01';
  String professionalMeet_madad_date = '1999-01-01';
  String mosadYeshiva_madad_date = '1999-01-01';
    String meet_madad_date = '1999-01-01';
  String matzbarmeet_madad_date = '1999-01-01';
  String hazana_madad_date = '1999-01-01';
    String groupMeet_madad_date = '1999-01-01';
  String eshcolMosadMeet_madad_date = '1999-01-01';
  String doForBogrim_madad_date = '1999-01-01';
    String cenes_madad_date = '1999-01-01';
  String call_madad_date = '1999-01-01';
  String callHorim_madad_date = '1999-01-01';
    String basis_madad_date = '1999-01-01';
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final auth = ref.watch(authServiceProvider);

    final jsonData =
        await HttpService.getMadadimSetting(auth.valueOrNull!.phone);
    final u = jsonDecode(jsonData.body);

    Logger().d(u);

    super.setState(() {
      basis_madad_date = u["basis_madad_date"];
      callHorim_madad_date = u["callHorim_madad_date"];
            call_madad_date = u["call_madad_date"];
      cenes_madad_date = u["cenes_madad_date"];
      doForBogrim_madad_date = u["doForBogrim_madad_date"];
            eshcolMosadMeet_madad_date = u["eshcolMosadMeet_madad_date"];
      groupMeet_madad_date = u["groupMeet_madad_date"];
      hazana_madad_date = u["hazana_madad_date"];
            matzbarmeet_madad_date = u["matzbarmeet_madad_date"];
      matzbarmeet_madad_date = u["matzbarmeet_madad_date"];
      meet_madad_date = u["meet_madad_date"];
            mosadYeshiva_madad_date = u["mosadYeshiva_madad_date"];
      professionalMeet_madad_date = u["professionalMeet_madad_date"];
      tochnitMeet_madad_date = u["tochnitMeet_madad_date"];
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'הגדרות מדדים ',
          style: TextStyles.s22w500cGrey2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'הגדרת זמני תחילת איסוף הנתונים',
              style: TextStyles.s16w400cGrey2,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _SettingsSection(
                    header: 'מלווים',
                    children: [
                      _SettingListTile(
                        leading: 'ביצוע שיחות',
                        trailing: call_madad_date,
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'ביצוע מפגשים',
                        trailing: meet_madad_date,
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'מפגשים קבוצתיים',
                        trailing: groupMeet_madad_date,
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'שיחות עם הורים',
                        trailing: callHorim_madad_date,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsSection(
                    header: 'רכזים',
                    children: [
                      _SettingListTile(
                        leading: 'מפגשים מקצועיים למלווים',
                        trailing: professionalMeet_madad_date,
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'ישיבות מצב”ר',
                        trailing: matzbarmeet_madad_date,
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'עשיה לטובת בוגרים',
                        trailing: doForBogrim_madad_date,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsSection(
                    header: 'רכזי אשכול',
                    children: [
                      _SettingListTile(
                        leading: 'ישיבה חודשית עם אחראי תוכנית',
                        trailing: tochnitMeet_madad_date,
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'ישיבה חודשית עם רכז',
                        trailing: mosadYeshiva_madad_date,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.header,
    required this.children,
  });

  final String header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            header,
            style: TextStyles.s20w500cGrey2,
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingListTile extends StatelessWidget {
  const _SettingListTile({
    required this.trailing,
    required this.leading,
    required this.onTap,
  });

  final String leading;
  final String trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        leading,
        style: TextStyles.s16w400cGrey2,
      ),
      trailing: TextButton.icon(
        onPressed: onTap,
        icon: Text(
          trailing,
          style: TextStyles.s14w300,
        ),
        label: const RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.chevron_left),
        ),
      ),
    );
  }
}
