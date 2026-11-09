import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentIdField extends StatelessWidget {
  const StudentIdField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'NIM',
        hintText: 'Contoh: A12345678',
        helperText: '1 huruf kode A-G, diikuti 8 digit angka',
        prefixIcon: Icon(Icons.badge_outlined),
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Ga-g0-9]')),
        LengthLimitingTextInputFormatter(9),
        TextInputFormatter.withFunction((oldValue, newValue) {
          return newValue.copyWith(
            text: newValue.text.toUpperCase(),
            selection: newValue.selection,
          );
        }),
      ],
    );
  }
}
