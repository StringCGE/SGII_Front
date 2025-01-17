import 'package:flutter/material.dart';
import 'package:sgii_front/util/my_widget/menu_opcions.dart';

class Opcion {
  String nombre; // Nombre de la opción
  List<Opcion> opciones; // Lista de sub-opciones
  Function(BuildContext context, MenuOptions mo) ejecutar; // Función que se ejecuta cuando se invoca
  IconData? icono; // Propiedad opcional para el IconData
  bool isSubmenuVisible; // Indica si el submenú debe ser visible

  Opcion({
    required this.nombre,
    this.opciones = const [],
    required this.ejecutar,
    this.icono,
    this.isSubmenuVisible = false,
  });
}