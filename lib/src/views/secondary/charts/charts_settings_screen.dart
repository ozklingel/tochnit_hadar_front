import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartsSettingsScreen extends ConsumerWidget {
  const ChartsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
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
                        trailing: '24/09/2023',
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'ביצוע מפגשים',
                        trailing: '24/09/2023',
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'מפגשים קבוצתיים',
                        trailing: '24/09/2023',
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'שיחות עם הורים',
                        trailing: '24/09/2023',
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
                        trailing: '24/09/2023',
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'ישיבות מצב”ר',
                        trailing: '24/09/2023',
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'עשיה לטובת בוגרים',
                        trailing: '24/09/2023',
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
                        trailing: '24/09/2023',
                        onTap: () {},
                      ),
                      _SettingListTile(
                        leading: 'ישיבה חודשית עם רכז',
                        trailing: '24/09/2023',
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'מלווים',
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
