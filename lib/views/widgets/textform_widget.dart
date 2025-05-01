import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final IconData? icon;
  final String label;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  const TextFormFieldWidget({
    this.icon,
    required this.label,
    required this.textEditingController,
    this.validator,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: textEditingController,
      obscureText: label.toLowerCase().contains('password'),
      onChanged: (value) {
        onChanged;
      },
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        floatingLabelStyle: theme.textTheme.titleLarge,
        icon: Icon(icon, color: theme.colorScheme.primary),
        labelText: label,
      ),
    );
  }
}
