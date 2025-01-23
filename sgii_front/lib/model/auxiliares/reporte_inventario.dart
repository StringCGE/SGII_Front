import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sgii_front/model/cls_producto.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Inventario {
  final List<Producto> productos;

  String? _pdfUrl;

  Inventario(this.productos);

  double calcularValorTotal() {
    return productos.fold(0, (total, producto) => total + producto.valorTotal);
  }

  double calcularPromedioPrecios() {
    if (productos.isEmpty) return 0.0;
    final double totalPrecios = productos.fold(0, (total, producto) => total + producto.precio);
    return totalPrecios / productos.length;
  }

  int calcularCantidadTotalProductos() {
    return productos.fold(0, (total, producto) => total + producto.cantidad);
  }

  Future<void> generarReportePDF() async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/font/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Inventario', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
              pw.Divider(),
              pw.ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return pw.Text(
                      '${producto.nombre} - Precio: \$${producto.precio.toStringAsFixed(2)} - Cantidad: ${producto.cantidad} - Valor Total: \$${producto.valorTotal.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf));  // Aplica la fuente personalizada
                },
              ),
              pw.Divider(),
              pw.Text('Cantidad Total de Productos: ${calcularCantidadTotalProductos()}', style: pw.TextStyle(font: ttf)),
              pw.Text('Valor Total del Inventario: \$${calcularValorTotal().toStringAsFixed(2)}', style: pw.TextStyle(font: ttf)),
              pw.Text('Promedio de Precios: \$${calcularPromedioPrecios().toStringAsFixed(2)}', style: pw.TextStyle(font: ttf)),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    // Guardar el archivo PDF generado
    html.Blob blob = html.Blob([bytes], 'application/pdf');
    _pdfUrl = html.Url.createObjectUrlFromBlob(blob);
  }

  String presentarReporteTexto() {
    final buffer = StringBuffer();

    buffer.writeln('Reporte de Inventario');
    buffer.writeln('---------------------');
    for (var producto in productos) {
      buffer.writeln(
          '${producto.nombre} - Precio: \$${producto.precio.toStringAsFixed(2)} - Cantidad: ${producto.cantidad} - Valor Total: \$${producto.valorTotal.toStringAsFixed(2)}');
    }
    buffer.writeln('---------------------');
    buffer.writeln('Cantidad Total de Productos: ${calcularCantidadTotalProductos()}');
    buffer.writeln('Valor Total del Inventario: \$${calcularValorTotal().toStringAsFixed(2)}');
    buffer.writeln('Promedio de Precios: \$${calcularPromedioPrecios().toStringAsFixed(2)}');

    return buffer.toString();
  }

  // Método para presentar el reporte como un Widget
  Widget presentarReporteWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reporte de Inventario', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Divider(),
        ...productos.map((producto) {
          return Text(
              '${producto.nombre} - Precio: \$${producto.precio.toStringAsFixed(2)} - Cantidad: ${producto.cantidad} - Valor Total: \$${producto.valorTotal.toStringAsFixed(2)}');
        }).toList(),
        Divider(),
        Text('Cantidad Total de Productos: ${calcularCantidadTotalProductos()}'),
        Text('Valor Total del Inventario: \$${calcularValorTotal().toStringAsFixed(2)}'),
        Text('Promedio de Precios: \$${calcularPromedioPrecios().toStringAsFixed(2)}'),
      ],
    );
  }

  // Método para obtener la URL generada
  String? getPdfUrl() {
    return _pdfUrl;
  }
}