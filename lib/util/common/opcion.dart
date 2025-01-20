import 'package:flutter/material.dart';
import 'package:sgii_front/util/my_widget/menu_opcions.dart';

class Opcion {
  String nombre; // Nombre de la opción
  List<Opcion> opciones; // Lista de sub-opciones
  Function(BuildContext context, MenuOptions mo) ejecutar; // Función que se ejecuta cuando se invoca
  IconData? icono; // Propiedad opcional para el IconData
  bool isSubmenuVisible; // Indica si el submenú debe ser visible
  late List<String> roles;
  late bool esOpcion;
  Opcion({
    required this.nombre,
    required this.roles,
    required this.esOpcion,
    this.opciones = const [],
    required this.ejecutar,
    this.icono,
    this.isSubmenuVisible = false,
  });

  bool seMuestra(List<String> userRoles) {
    /*if (roles.isNotEmpty && roles.any((role) => userRoles.contains(role))) {
      return true;
    }*/
    // Si no es seleccionable (esOpcion false), verifica si alguna sub-opción debe mostrarse
    if (esOpcion) {
      return roles.isNotEmpty && roles.any((role) => userRoles.contains(role));
    }
    if (!esOpcion) {
      return opciones.any((subOpcion) => subOpcion.seMuestra(userRoles));
    }
    return false;
  }

  // Método estático para filtrar la lista según los roles del usuario
  static List<Opcion> filtrarOpcionesPorRoles(List<Opcion> opciones, List<String> userRoles) {
    return opciones
        .where((opcion) => opcion.seMuestra(userRoles)) // Filtra opciones visibles
        .map((opcion) => Opcion(
      nombre: opcion.nombre,
      roles: opcion.roles,
      esOpcion: opcion.esOpcion,
      opciones: filtrarOpcionesPorRoles(opcion.opciones, userRoles), // Aplica recursión a las sub-opciones
      ejecutar: opcion.ejecutar,
      icono: opcion.icono,
      isSubmenuVisible: opcion.isSubmenuVisible,
    ))
        .toList();
  }

}