import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  TextWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey), // Borde interno gris
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
//Clase que duplica TextWidget, no s epuede hacer mas por cuestion de tiempo

class LineTextWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double labelWidth;

  LineTextWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.labelWidth = 100,
  });

  @override
  Widget build(BuildContext context) {
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
