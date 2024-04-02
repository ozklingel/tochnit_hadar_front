import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theming/colors.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/networking/http_service.dart';
import '../../../services/routing/go_router_provider.dart';
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
    Dialog dialog1=Dialog(
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
          

           Column(
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
      FilledButton(
        onPressed:  ()async {
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
              },
        style: FilledButton.styleFrom(
          fixedSize: const Size(double.infinity, 60),
          side: const BorderSide(
            color: AppColors.blue03,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: backgroundColor,
          disabledBackgroundColor: AppColors.blue07,
        ),
        child: Text(
          label,
          style: textStyle.copyWith(
            color: foregroundColor,
            fontSize: 16,
          ),
        ),
      ),
    
       FilledButton(
        onPressed: ()=>{},
        style: FilledButton.styleFrom(
          fixedSize: const Size(double.infinity, 60),
          side: const BorderSide(
            color: AppColors.blue03,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: backgroundColor,
          disabledBackgroundColor: AppColors.blue07,
        ),
        child: Text(
          label,
          style: textStyle.copyWith(
            color: foregroundColor,
            fontSize: 16,
          ),
        ),
      ),]),
        ],
      ),
    ),
  );
  
   
 return SizedBox.fromSize(
      size: const Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.white, // button color
          child: InkWell(
            splashColor: Colors.white, // splash color
            onTap: () async {
                showDialog(context: context, builder: (BuildContext context) => dialog1);
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
