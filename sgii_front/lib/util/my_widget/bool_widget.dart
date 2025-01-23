import 'package:flutter/material.dart';

class BoolWidget extends StatefulWidget {
  final String labelText;
  final bool Function() getValue;
  final void Function(bool value) setValue;

  BoolWidget({
    super.key,
    required this.labelText,
    required this.setValue,
    required this.getValue,
  });

  @override
  _BoolWidgetState createState() => _BoolWidgetState();
}

class _BoolWidgetState extends State<BoolWidget> {
  late bool currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.getValue(); // Obtener el valor inicial
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
          SwitchListTile(
            value: currentValue,
            onChanged: (value) {
              setState(() {
                currentValue = value; // Actualizar el estado
                widget.setValue(value); // Notificar el cambio al valor externo
              });
            },
            title: Text(
              widget.labelText,
              style: const TextStyle(
                fontSize: 16, // Tamaño del texto
                fontWeight: FontWeight.bold,
              ),
            ),
            activeColor: Colors.green, // Color cuando está activado
            inactiveThumbColor: Colors.red, // Color cuando está desactivado
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

