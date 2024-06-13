import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';

class GeneralDropdownButton<T> extends StatelessWidget {
  const GeneralDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.stringMapper,
    this.textStyle,
    this.onMenuStateChange,
    this.searchController,
    this.searchMatchFunction,
  });

  final String value;
  final List<T> items;
  final String Function(T)? stringMapper;
  final void Function(T?) onChanged;
  final TextStyle? textStyle;
  final void Function(bool)? onMenuStateChange;
  final TextEditingController? searchController;
  final bool Function(DropdownMenuItem<T>, String)? searchMatchFunction;

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
      child: DropdownButton2<T>(
        hint: Text(
          value,
          overflow: TextOverflow.fade,
        ),
        style: textStyle ?? Theme.of(context).inputDecorationTheme.hintStyle,
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
        dropdownSearchData: searchController == null
            ? null
            : DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: TextFormField(
                  controller: searchController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'נא למלא';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(),
                    enabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'חיפוש',
                    hintStyle: TextStyles.s14w400,
                  ),
                ),
                searchMatchFn: searchMatchFunction,
              ),
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
                child: Text(
                  stringMapper != null ? stringMapper!(e) : e.toString(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
