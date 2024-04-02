import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/networking/http_service.dart';
import '../../primary/pages/home/views/widgets/success_dialog.dart';

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
  Widget build(BuildContext context,ref) {
    final auth = ref.watch(authServiceProvider);

    return SizedBox.fromSize(
      size: const Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.white, // button color
          child: InkWell(
            splashColor: Colors.white, // splash color
            onTap: () async {
                        debugPrint("object");

                        String result = await HttpService.deleteGiftAll(
                          auth.valueOrNull?.id,
                        );
                        if (result == "success") {
                          // print("in");
                          // ignore: use_build_context_synchronously
                          showFancyCustomDialog(context);
                        } else {
                          // print("in");

                          // ignore: use_build_context_synchronously
                        }
                      }, // button pressed
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
