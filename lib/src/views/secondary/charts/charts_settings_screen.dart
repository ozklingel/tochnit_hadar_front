import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hadar_program/src/services/networking/http_service.dart';
import 'package:hadar_program/src/services/storage/storage_service.dart';
import 'package:hadar_program/src/views/secondary/charts/melave/models/chart_settings.dto.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartsSettingsScreen extends HookConsumerWidget {
  const ChartsSettingsScreen({super.key});

  _getNewDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.blue01,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useState<ChartSettingsDto?>(null);
    final phone = ref.read(storageServiceProvider.notifier).getUserPhone();
    final result = useMemoized(() => HttpService.getMadadimSetting(phone));
    final response = useFuture(result);
    if (response.hasData) {
      state.value ??= ChartSettingsDto.fromJson(jsonDecode(response.data.body));
    }
    final chartSettings = state.value;

    void updateField(String field) async {
      final newDate = await _getNewDate(context);
      if (newDate == null) return;
      final stringDate = newDate.toString().split(" ")[0];
      var result =
          await HttpService.setSettingMadadim(phone, field, stringDate);
      if (result == 'success') {
        final newJson = state.value?.toJson() ?? {};
        newJson[field] = stringDate;
        state.value = ChartSettingsDto.fromJson(newJson);
      }
    }

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
                children: chartSettings == null
                    ? [const CircularProgressIndicator.adaptive()]
                    : [
                        _SettingsSection(
                          header: 'מלווים',
                          children: [
                            _SettingListTile(
                              leading: 'ביצוע שיחות',
                              trailing: chartSettings.callMadadDate,
                              onTap: () => updateField('call_madad_date'),
                            ),
                            _SettingListTile(
                              leading: 'ביצוע מפגשים',
                              trailing: chartSettings.meetMadadDate,
                              onTap: () => updateField('meet_madad_date'),
                            ),
                            _SettingListTile(
                              leading: 'מפגשים קבוצתיים',
                              trailing: chartSettings.groupMeetMadadDate,
                              onTap: () => updateField('groupMeet_madad_date'),
                            ),
                            _SettingListTile(
                              leading: 'שיחות עם הורים',
                              trailing: chartSettings.callHorimMadadDate,
                              onTap: () => updateField('callHorim_madad_date'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _SettingsSection(
                          header: 'רכזים',
                          children: [
                            _SettingListTile(
                              leading: 'מפגשים מקצועיים למלווים',
                              trailing: chartSettings.professionalMeetMadadDate,
                              onTap: () =>
                                  updateField('professionalMeet_madad_date'),
                            ),
                            _SettingListTile(
                              leading: 'ישיבות מצב”ר',
                              trailing: chartSettings.matzbarMeetMadadDate,
                              onTap: () =>
                                  updateField('matzbarmeet_madad_date'),
                            ),
                            _SettingListTile(
                              leading: 'עשיה לטובת בוגרים',
                              trailing: chartSettings.doForBogrimMadadDate,
                              onTap: () =>
                                  updateField('doForBogrim_madad_date'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _SettingsSection(
                          header: 'רכזי אשכול',
                          children: [
                            _SettingListTile(
                              leading: 'ישיבה חודשית עם אחראי תוכנית',
                              trailing: chartSettings.tochnitMeetMadadDate,
                              onTap: () =>
                                  updateField('tochnitMeet_madad_date'),
                            ),
                            _SettingListTile(
                              leading: 'ישיבה חודשית עם רכז',
                              trailing: chartSettings.mosadYeshivaMadadDate,
                              onTap: () =>
                                  updateField('mosadYeshiva_madad_date'),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
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
          trailing.split('-').reversed.toList().join('/'),
          style: TextStyles.s14w300,
        ),
        label: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}
