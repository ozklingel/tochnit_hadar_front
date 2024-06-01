import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/networking/http_service.dart';
import '../../../services/routing/go_router_provider.dart';
import 'large_filled_rounded_button.dart';

class DeleteButton extends HookConsumerWidget {
  const DeleteButton({
    super.key,
    required this.label,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.white,
    this.textStyle = TextStyles.s24w500cGrey2,
    this.fontSize,
    this.height,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double? fontSize;
  final double? height;

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox.fromSize(
      size: const Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.white, // button color
          child: InkWell(
            splashColor: Colors.white, // splash color
            onTap: () async => await showDialog(
              context: context,
              builder: (context) => const _ConfirmSignoutDialog(),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.delete_outlined), // icon
                Text("מחק"), // text
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmSignoutDialog extends ConsumerWidget {
  const _ConfirmSignoutDialog();

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authServiceProvider);
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
                'מחיקת קודים',
                style: TextStyles.s24w400,
              ),
              const Text(
                'פעולה זו תסיר את הקודים הקיימים',
                style: TextStyles.s16w400cGrey3,
              ),
              const Text(
                'האם אתה בטוח שברצונך להסירם מהמערכת?',
                style: TextStyles.s16w400cGrey3,
              ),
              const SizedBox(height: 12),
              LargeFilledRoundedButton(
                label: ' לא השאר אותם',
                onPressed: () => Navigator.of(context).pop(),
                height: 46,
              ),
              LargeFilledRoundedButton.cancel(
                label: 'מחק',
                onPressed: () async {
                  String result = await HttpService.deleteGiftAll(
                    auth.valueOrNull?.id,
                  );
                  if (result == "success") {
                    // print("in");
                    // ignore: use_build_context_synchronously
                    showDeleteDialog(context);
                  } else {
                    // print("in");

                    // ignore: use_build_context_synchronously
                  }
                },
                height: 46,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showDeleteDialog(BuildContext context) {
  Dialog fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 350.0,
      width: 300.0,
      child: Stack(
        children: <Widget>[
          Align(
            // These values are based on trial & error method
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Align(
            // These values are based on trial & error method
            alignment: Alignment.bottomLeft,
            child: InkWell(
              onTap: () {
                const HomeRouteData().go(context);
              },
              child: const SizedBox(
                child: Image(
                  image: AssetImage('assets/images/backhome.png'),
                ),
              ),
            ),
          ),
          const Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(top: 2, bottom: 10, left: 2, right: 2),
                child: Image(
                  width: 150,
                  height: 160,
                  image: AssetImage('assets/images/mechiot_capayim.png'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 5,
              ),
              Text(
                ' קודים נמחקו  כנשלחה',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                height: 20,
              ),
              Text(
                'ישר כוח!',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}
