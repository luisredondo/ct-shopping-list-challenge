import 'package:flutter/material.dart';

import 'package:ct_shopping_list_challenge/utils/constants.dart' as constants;

class MyTextFormField extends StatelessWidget {
  
  const MyTextFormField({
    this.controller,
    this.inputPlaceholder,
    this.onBeforeValidate,
    this.onChanged,
    this.validator,
    this.minLines,
    this.maxLines,
    this.enabled,
    this.lightColor,
    this.darkColor,
  });

  final TextEditingController? controller;
  final String? inputPlaceholder;
  final Future<void> Function(String)? onBeforeValidate;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final bool? enabled;
  final Color? lightColor;
  final Color? darkColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        enabledBorder: getDefaultBorder(),
        focusedBorder: getDefaultBorder(),
        disabledBorder: getDefaultBorder(),
        hintText: inputPlaceholder,
        hintStyle: const TextStyle(
          color: constants.secondaryColor,
        ),
      ),
    );
  }

  InputBorder getDefaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: constants.primaryColor,
      ),
    );
  }

}
