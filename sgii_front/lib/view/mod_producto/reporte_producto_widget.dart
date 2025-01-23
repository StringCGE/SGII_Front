import 'package:flutter/material.dart';
import 'package:sgii_front/model/auxiliares/reporte_inventario.dart';
import 'package:sgii_front/model/cls_producto.dart';
import 'package:sgii_front/service/serv_producto.dart';
import 'dart:html' as html;

class ReporteProductoWidget extends StatefulWidget {

  const ReporteProductoWidget({
    super.key,

  });

  @override
  ReporteProductoWidgetState createState() => ReporteProductoWidgetState();
}

class ReporteProductoWidgetState extends State<ReporteProductoWidget> {
  final ProductoService productoS = ProductoService();
  List<Producto> productos = [];
  bool isLoading = true; // Indicador para mostrar un estado de carga
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final result = await productoS.getAll();
    if (result.success) {
      setState(() {
        productos = result.value ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = result.errror ?? 'Error desconocido al cargar los productos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Indicador de carga
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }
    final inventario = Inventario(productos);

    return SingleChildScrollView(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Eeste reporte no esta naaaada bonito",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  tooltip: 'Descargar contenido',
                  onPressed: () async {
                    inventario.generarReportePDF();
                    try{
                      final String pdfUrl = inventario.getPdfUrl() ?? '';
                      if (pdfUrl.isNotEmpty) {
                        // Crear un enlace <a> para simular la descarga
                        final html.AnchorElement anchor = html.AnchorElement(href: pdfUrl)
                          ..setAttribute('download', 'reporte.pdf')  // Nombre del archivo a descargar
                          ..click();  // Dispara el evento de clic para descargar el archivo
                      } else {
                        print('No se pudo obtener la URL del PDF');
                      }
                    }catch(e){
                      int i = 0;
                    }
                  },
                )
              ],
            ),
            const Divider(),
            inventario.presentarReporteWidget(), // Mostrar el reporte del inventario como Widget
          ],
        ),
      ),
    );
  }
}