import 'package:flutter/material.dart';

class ComboStringWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final List<String> lista;

  const ComboStringWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.lista,
  });

  @override
  ComboStringWidgetState createState() => ComboStringWidgetState();
}

class ComboStringWidgetState extends State<ComboStringWidget> {
  void _selectItem(BuildContext context) async {
    final selectedItem = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Seleccione una opción"),
          children: widget.lista.map((item) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, item),
              child: Text(item),
            );
          }).toList(),
        );
      },
    );

    if (selectedItem != null) {
      setState(() {
        widget.controller.text = selectedItem;
      });
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
            widget.labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey), // Borde interno gris
              ),
              suffixIcon: GestureDetector(
                onTap: () => _selectItem(context),
                child: const Icon(
                  Icons.list,
                  color: Colors.grey,
                ),
              ),
            ),
            readOnly: true,
            onTap: () => _selectItem(context),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}


/*

ComboStringWidget(
    controller: _sexoController,
    labelText: "mod_sexo",
    hintText: "Escriba la cedula",
    validator: validateNotEmpty,
    lista: ["Masculino", "Femenino", "Si no te identificas por genitales, las audas medicas no estan permitidas"]
),

*/