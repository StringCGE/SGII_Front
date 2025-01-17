import 'package:flutter/material.dart';

class DineroWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String currencyText; // Ahora es un String para aceptar cualquier texto, como "USD" o "$"
  final String? Function(String?)? validator;

  DineroWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.currencyText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50], // Fondo celeste
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Sombra suave
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // Desplazamiento de la sombra
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16, // Tamaño del texto más pequeño
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // Reducir el espacio entre el texto y el campo
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              prefixText: currencyText, // Muestra el texto de la moneda (USD, $, etc.)
              prefixStyle: const TextStyle(
                fontSize: 16, // Tamaño del texto del símbolo de la moneda
                fontWeight: FontWeight.bold,
                color: Colors.grey, // Color del texto de la moneda
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey), // Borde interno gris
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true), // Permite entrada de números decimales
            validator: validator,
          ),
        ],
      ),
    );
  }
}



