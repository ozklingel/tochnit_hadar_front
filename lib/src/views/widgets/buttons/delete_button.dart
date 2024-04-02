import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class delete_button extends StatelessWidget {
  const delete_button({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.white,
    this.textStyle = TextStyles.s24w500cGrey2,
    this.fontSize,
    this.height,
  });



  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double? fontSize;
  final double? height;

  @override
  Widget build(BuildContext context) {
    print("22222");
    return SizedBox.fromSize(
  size: Size(56, 56), // button width and height
  child: ClipOval(
    child: Material(
      color: Colors.white, // button color
      child: InkWell(
        splashColor: Colors.white, // splash color
        onTap: () =>onPressed, // button pressed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.delete_outlined), // icon
            Text("מחק"), // text
          ],
        ),
      ),
    ),
  ),
);}
}
