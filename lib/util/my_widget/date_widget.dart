import 'package:flutter/material.dart';


class DateWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  DateWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2101);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      String formattedDate = '${pickedDate.toLocal()}'.split(' ')[0];
      controller.text = formattedDate;
    }
  }

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
              suffixIcon: GestureDetector(
                onTap: () => _selectDate(context),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: validator,
          ),
        ],
      ),
    );
  }
}


