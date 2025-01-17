import 'package:flutter/material.dart';

class DateTimeWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  DateTimeWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
  });

  Future<void> _selectDateTime(BuildContext context) async {
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
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDateTime = '${selectedDateTime.toLocal()}'.split(' ')[0] +
            ' ' +
            selectedDateTime.toLocal().toString().split(' ')[1].substring(0, 5);

        controller.text = formattedDateTime;
      }
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
                onTap: () => _selectDateTime(context), // Mostrar DatePicker y TimePicker al hacer clic
                child: const Icon(
                  Icons.calendar_today, // Ícono de calendario
                  color: Colors.grey,
                ),
              ),
            ),
            readOnly: true, // Hace que el campo no sea editable directamente
            onTap: () => _selectDateTime(context), // Mostrar DatePicker y TimePicker al hacer clic en el TextField
            validator: validator,
          ),
        ],
      ),
    );
  }
}

