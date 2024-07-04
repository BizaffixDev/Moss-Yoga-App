import 'package:flutter/services.dart';


class InternationalPhoneFormatter extends TextInputFormatter {
  String internationalPhoneFormat(value) {
    String nums = value.replaceAll(RegExp(r'[\D]'), '');

    // Remove the first digit if it is '1' because we are appending it by default.
    if (nums.startsWith('1')) {
      nums = nums.substring(1);
    }

    String internationalPhoneFormatted = nums.isNotEmpty
        ?
            (nums.isNotEmpty ? '(' : '') +
            nums.substring(0, nums.length >= 3 ? 3 : null) +
            (nums.length >= 3 ? ') ' : '') +
            (nums.length > 3
                ? nums.substring(3, nums.length >= 6 ? 6 : null) +
                    (nums.length > 6
                        ? '-${nums.substring(6, nums.length >= 10 ? 10 : null)}'
                        : '')
                : '')
        : '+1 ';
    return internationalPhoneFormatted;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    return newValue.copyWith(
        text: internationalPhoneFormat(text),
        selection: TextSelection.collapsed(
            offset: internationalPhoneFormat(text).length));
  }
}
