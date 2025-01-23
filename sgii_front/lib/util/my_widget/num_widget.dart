import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sgii_front/util/common/mi_formato.dart';

class NumWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool allowDecimals;
  final bool readOnly;

  NumWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.allowDecimals,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    String pattern = allowDecimals
        ? r'^\d+([.,]\d{0,2})?$'
        : r'^\d+$';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: readOnly,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              MiFormateador(pattern),
            ],
            validator: validator,
          ),
        ],
      ),
    );
  }
}


class LineNumWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool allowDecimals;
  final double labelWidth;
  final bool readOnly;

  LineNumWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.allowDecimals,
    this.labelWidth = 100,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    String pattern = allowDecimals ? r'^\d+([.,]\d{0,2})?$' : r'^\d+$';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Asegura que los elementos estén centrados
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              labelText,
              style: const TextStyle(
                fontSize: 12, // Tamaño más pequeño
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis, // Oculta texto que sobresale
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 30, // Altura fija para el TextFormField
              child: TextFormField(
                readOnly: readOnly,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4), // Bordes del campo
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4, // Ajuste del padding vertical
                    horizontal: 8,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  MiFormateador(pattern),
                ],
                validator: validator,
                style: const TextStyle(fontSize: 12), // Tamaño de texto pequeño
              ),
            ),
          ),
        ],
      ),
    );
  }
}






