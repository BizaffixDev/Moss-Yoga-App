import 'package:flutter/material.dart';
import 'package:moss_yoga/common/resources/colors.dart';

import '../resources/strings.dart';
import '../resources/text_styles.dart';

class StdCustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool? obscure;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final double? m;
  final String? Function(String?)? validator;
  final VoidCallback? obscureIconLogic;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final bool? isReadONly;
  ValueChanged<String>? onChanged;
  bool isFieldValid;
  String? errorText;

  StdCustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.obscure = false,
    this.controller,
    this.m = 40,
    this.textInputType,
    this.validator,
    this.obscureIconLogic,
    this.suffixIcon,
    this.onChanged,
    this.isFieldValid = true,
    this.errorText,
    this.onTap,
    this.isReadONly = false,
  });

  @override
  State<StdCustomTextField> createState() => _StdCustomTextFieldState();
}

class _StdCustomTextFieldState extends State<StdCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.m!),
      child: TextFormField(
        readOnly: widget.isReadONly ?? false,
        onChanged: widget.onChanged,
        controller: widget.controller,
        obscureText: widget.obscure!,
        keyboardType: widget.textInputType,
        validator: widget.validator ?? _defaultValidator,
        onTap: widget.onTap,
        decoration: InputDecoration(
          errorText: widget.isFieldValid ? null : widget.errorText ?? '',
          hintText: widget.hintText,
          hintStyle: manropeSubTitleTextStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.greyTextColor,
          ),
          labelText: widget.labelText,
          labelStyle: manropeSubTitleTextStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.greyTextColor,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.greyTextColor),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              widget.suffixIcon,
              // widget.obscure! == true ? Icons.visibility : Icons.visibility_off
            ),
            onPressed: widget.obscureIconLogic,
          ),
          suffixIconColor: AppColors.primaryColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.greyTextColor,
            ),
          ),
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value?.trim() == null || value!.trim().isEmpty) {
      return 'Please enter your email';
    } else if (!_isValidEmail(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  bool _isValidEmail(String email) {
    String newEmail = email.trim();
    return Strings.emailRegex.hasMatch(newEmail);
  }
}
