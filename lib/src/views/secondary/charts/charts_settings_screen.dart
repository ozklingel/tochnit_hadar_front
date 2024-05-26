import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theming/colors.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/networking/http_service.dart';

class ChartsSettingsScreen extends StatefulHookConsumerWidget {
  const ChartsSettingsScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<ChartsSettingsScreen> createState() => _SettingPageState();
}

final callMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final basisMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final callHorimMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final cenesMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final doForBogrimMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final eshcolMosadMeetMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final groupMeetMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final hazanaMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final meetMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final mosadYeshivaMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final professionalMeetMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final tochnitMeetMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});
final matzbarmeetMadadDateProvider = StateProvider<String>((ref) {
  return '1999-01-01';
});

class _SettingPageState extends ConsumerState<ChartsSettingsScreen> {
//final userProvider = StateProvider<String>((ref) {return '1999-01-01';});
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final auth = ref.watch(authServiceProvider);
    final jsonData =
        await HttpService.getMadadimSetting(auth.valueOrNull!.phone);
    final u = jsonDecode(jsonData.body);

    String callMadadDate = u["call_madad_date"];
    String basisMadadDate = u["basis_madad_date"];
    String callhorimMadadDate = u["callHorim_madad_date"];
    String cenesMadadDate = u["cenes_madad_date"];
    String doforbogrimMadadDate = u["doForBogrim_madad_date"];
    String eshcolmosadmeetMadadDate = u["eshcolMosadMeet_madad_date"];
    String groupmeetMadadDate = u["groupMeet_madad_date"];
    // String hazanaMadadDate = u["hazana_madad_date"];
    String matzbarmeetMadadDate = u["matzbarmeet_madad_date"];
    String meetMadadDate = u["meet_madad_date"];
    String mosadyeshivaMadadDate = u["mosadYeshiva_madad_date"];
    String professionalmeetMadadDate = u["professionalMeet_madad_date"];
    String tochnitmeetMadadDate = u["tochnitMeet_madad_date"];

    ref.read(basisMadadDateProvider.notifier).state = basisMadadDate;
    ref.read(callMadadDateProvider.notifier).state = callMadadDate;
    ref.read(callHorimMadadDateProvider.notifier).state = callhorimMadadDate;
    ref.read(cenesMadadDateProvider.notifier).state = cenesMadadDate;
    ref.read(doForBogrimMadadDateProvider.notifier).state =
        doforbogrimMadadDate;
    ref.read(eshcolMosadMeetMadadDateProvider.notifier).state =
        eshcolmosadmeetMadadDate;
    ref.read(groupMeetMadadDateProvider.notifier).state = groupmeetMadadDate;
    ref.read(matzbarmeetMadadDateProvider.notifier).state =
        matzbarmeetMadadDate;
    ref.read(meetMadadDateProvider.notifier).state = meetMadadDate;
    ref.read(mosadYeshivaMadadDateProvider.notifier).state =
        mosadyeshivaMadadDate;
    ref.read(professionalMeetMadadDateProvider.notifier).state =
        professionalmeetMadadDate;
    ref.read(tochnitMeetMadadDateProvider.notifier).state =
        tochnitmeetMadadDate;
    ref.read(basisMadadDateProvider.notifier).state = basisMadadDate;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);

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
                        trailing: ref.watch(callMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "call_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref.read(callMadadDateProvider.notifier).state =
                                newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                      _SettingListTile(
                        leading: 'ביצוע מפגשים',
                        trailing: ref.watch(meetMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "meet_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref.read(meetMadadDateProvider.notifier).state =
                                newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                      _SettingListTile(
                        leading: 'מפגשים קבוצתיים',
                        trailing: ref.watch(groupMeetMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "groupMeet_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref
                                .read(groupMeetMadadDateProvider.notifier)
                                .state = newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                      _SettingListTile(
                        leading: 'שיחות עם הורים',
                        trailing: ref.watch(callHorimMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "callHorim_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref
                                .read(callHorimMadadDateProvider.notifier)
                                .state = newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsSection(
                    header: 'רכזים',
                    children: [
                      _SettingListTile(
                        leading: 'מפגשים מקצועיים למלווים',
                        trailing: ref.watch(professionalMeetMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "professionalMeet_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref
                                .read(
                                  professionalMeetMadadDateProvider.notifier,
                                )
                                .state = newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                      _SettingListTile(
                        leading: 'ישיבות מצב”ר',
                        trailing: ref.watch(matzbarmeetMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "matzbarmeet_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref
                                .read(matzbarmeetMadadDateProvider.notifier)
                                .state = newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                      _SettingListTile(
                        leading: 'עשיה לטובת בוגרים',
                        trailing: ref.watch(doForBogrimMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "doForBogrim_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref
                                .read(doForBogrimMadadDateProvider.notifier)
                                .state = newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsSection(
                    header: 'רכזי אשכול',
                    children: [
                      _SettingListTile(
                        leading: 'ישיבה חודשית עם אחראי תוכנית',
                        trailing: ref.watch(tochnitMeetMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "tochnitMeet_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref
                                .read(tochnitMeetMadadDateProvider.notifier)
                                .state = newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
                      ),
                      _SettingListTile(
                        leading: 'ישיבה חודשית עם רכז',
                        trailing: ref.watch(mosadYeshivaMadadDateProvider),
                        onTap: () async {
                          final newDate = await getNewDate();
                          if (newDate == null) {
                            return;
                          }
                          var result = await HttpService.setSettingMadadim(
                            auth.valueOrNull!.phone,
                            "mosadYeshiva_madad_date",
                            newDate.toString().split(" ")[0],
                          );
                          if (result == 'success') {
                            ref
                                .read(mosadYeshivaMadadDateProvider.notifier)
                                .state = newDate.toString().split(" ")[0];
                          } else {
                            //showAlertDialog(context);
                          }
                        },
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

  getNewDate() {
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
