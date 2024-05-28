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
final call_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final basis_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final callHorim_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final cenes_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final doForBogrim_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final eshcolMosadMeet_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final groupMeet_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final hazana_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final meet_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final mosadYeshiva_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final professionalMeet_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final tochnitMeet_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});
final matzbarmeet_madad_dateProvider = StateProvider<String>((ref) {return '1999-01-01';});

class _SettingPageState extends ConsumerState<ChartsSettingsScreen> {

//final userProvider = StateProvider<String>((ref) {return '1999-01-01';});
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final auth = ref.watch(authServiceProvider);
    final jsonData =
        await HttpService.getMadadimSetting(auth.valueOrNull!.phone);
    final u = jsonDecode(jsonData.body);
 
      String call_madad_date=u["call_madad_date"];
      String basis_madad_date = u["basis_madad_date"];
      String callHorim_madad_date = u["callHorim_madad_date"];
      String cenes_madad_date = u["cenes_madad_date"];
      String doForBogrim_madad_date = u["doForBogrim_madad_date"];
         String   eshcolMosadMeet_madad_date = u["eshcolMosadMeet_madad_date"];
      String groupMeet_madad_date = u["groupMeet_madad_date"];
      String hazana_madad_date = u["hazana_madad_date"];
          String  matzbarmeet_madad_date = u["matzbarmeet_madad_date"];
      String meet_madad_date = u["meet_madad_date"];
          String  mosadYeshiva_madad_date = u["mosadYeshiva_madad_date"];
      String professionalMeet_madad_date = u["professionalMeet_madad_date"];
      String tochnitMeet_madad_date = u["tochnitMeet_madad_date"];

      ref.read(basis_madad_dateProvider.notifier).state=basis_madad_date;
      ref.read(call_madad_dateProvider.notifier).state=call_madad_date;
      ref.read(callHorim_madad_dateProvider.notifier).state=callHorim_madad_date;
      ref.read(cenes_madad_dateProvider.notifier).state=cenes_madad_date;
      ref.read(doForBogrim_madad_dateProvider.notifier).state=doForBogrim_madad_date;
      ref.read(eshcolMosadMeet_madad_dateProvider.notifier).state=eshcolMosadMeet_madad_date;
      ref.read(groupMeet_madad_dateProvider.notifier).state=groupMeet_madad_date;
      ref.read(matzbarmeet_madad_dateProvider.notifier).state=matzbarmeet_madad_date;
      ref.read(meet_madad_dateProvider.notifier).state=meet_madad_date;
      ref.read(mosadYeshiva_madad_dateProvider.notifier).state=mosadYeshiva_madad_date;
      ref.read(professionalMeet_madad_dateProvider.notifier).state=professionalMeet_madad_date;
      ref.read(tochnitMeet_madad_dateProvider.notifier).state=tochnitMeet_madad_date;
      ref.read(basis_madad_dateProvider.notifier).state=basis_madad_date;

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
                        trailing: ref.watch(call_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"call_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(call_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
                          } else {
                            //showAlertDialog(context);
                          }
                      },
                    ),     _SettingListTile(
                        leading: 'ביצוע מפגשים',
                        trailing: ref.watch(meet_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"meet_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(meet_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
                          } else {
                            //showAlertDialog(context);
                          }
                      },
                    ),
                         _SettingListTile(
                        leading: 'מפגשים קבוצתיים',
                        trailing: ref.watch(groupMeet_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"groupMeet_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(groupMeet_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
                          } else {
                            //showAlertDialog(context);
                          }
                      },
                    ),
                     _SettingListTile(
                        leading: 'שיחות עם הורים',
                        trailing: ref.watch(callHorim_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"callHorim_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(callHorim_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
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
                        trailing: ref.watch(professionalMeet_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"professionalMeet_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(professionalMeet_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
                          } else {
                            //showAlertDialog(context);
                          }
                      },
                    ),
                     _SettingListTile(
                        leading: 'ישיבות מצב”ר',
                        trailing: ref.watch(matzbarmeet_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"matzbarmeet_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(matzbarmeet_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
                          } else {
                            //showAlertDialog(context);
                          }
                      },
                    ),
                      _SettingListTile(
                        leading: 'עשיה לטובת בוגרים',
                        trailing: ref.watch(doForBogrim_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"doForBogrim_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(doForBogrim_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
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
                        trailing: ref.watch(tochnitMeet_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"tochnitMeet_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(tochnitMeet_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
                          } else {
                            //showAlertDialog(context);
                          }
                      },
                    ),
                     _SettingListTile(
                        leading: 'ישיבה חודשית עם רכז',
                        trailing: ref.watch(mosadYeshiva_madad_dateProvider),
                        onTap:() async {              
                        final newDate = await getNewDate();
                            if (newDate == null) {return;}
                                var result =await HttpService.setSettingMadadim(auth.valueOrNull!.phone,"mosadYeshiva_madad_date", newDate.toString().split(" ")[0]);
                            if (result=='success') {
                              ref.read(mosadYeshiva_madad_dateProvider.notifier).state=newDate.toString().split(" ")[0];;
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
                        initialDate:
                            DateTime.now(),
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
