import 'package:flutter/services.dart';

class MiFormateador extends TextInputFormatter {
  final RegExp regExp;
  MiFormateador(String pattern) : regExp = RegExp(pattern);
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) return newValue;
    if (regExp.hasMatch(newValue.text)) return newValue;
    return oldValue;
  }
}
