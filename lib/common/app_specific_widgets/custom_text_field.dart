import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moss_yoga/common/resources/colors.dart';

import '../resources/strings.dart';
import '../resources/text_styles.dart';

class CustomTextField extends StatefulWidget {
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
  TextInputAction? textInputAction;
  bool isFieldValid;
  String? errorText;
  FocusNode? focusNode;
  VoidCallback? onSubmit;
  List<TextInputFormatter>? textInputFormatterList;

  CustomTextField({
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
    this.focusNode,
    this.onSubmit,
    this.textInputAction,
    this.textInputFormatterList,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.m!),
      child: TextFormField(
        inputFormatters: widget.textInputFormatterList,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onSubmit,
        focusNode: widget.focusNode,
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
