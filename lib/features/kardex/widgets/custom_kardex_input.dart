import 'package:flutter/material.dart';
import 'kardex_style.dart';

class CustomKardexInput extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Color? hintColor;
  final String? Function(String?)? validator;

  const CustomKardexInput({
    super.key,
    required this.icon,
    required this.label,
    this.hintText,
    this.controller,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.hintColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator ?? (value) {
            if (!readOnly && (value == null || value.trim().isEmpty)) {
              return 'Campo requerido';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText ?? 'Ej: $label',
            hintStyle: TextStyle(
              color: hintColor ?? Colors.grey[500],
              fontSize: 15,
            ),
            prefixIcon: Padding(
              padding: maxLines > 1 
                  ? const EdgeInsets.only(bottom: 50.0) 
                  : EdgeInsets.zero,
              child: Icon(icon, color: Colors.grey[500], size: 22),
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: KardexStyle.grisCampo,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}
