import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';

class PersonaDropdownButton extends StatelessWidget {
  const PersonaDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.onMenuStateChange,
    this.dropdownSearchData,
  });

  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final void Function(bool)? onMenuStateChange;
  final DropdownSearchData<String>? dropdownSearchData;

  Widget _arrowIcon({bool isDown = true}) => Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Icon(
          isDown ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
          color: AppColors.grey6,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: Text(
          value,
          overflow: TextOverflow.fade,
        ),
        style: Theme.of(context).inputDecorationTheme.hintStyle,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.shade04,
            ),
          ),
          elevation: 0,
          padding: const EdgeInsets.only(right: 8),
        ),
        onChanged: onChanged,
        onMenuStateChange: onMenuStateChange,
        dropdownSearchData: dropdownSearchData,
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: _arrowIcon(),
          openMenuIcon: _arrowIcon(isDown: false),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
