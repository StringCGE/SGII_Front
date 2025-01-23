import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_factura_nota_credito.dart';
import 'package:sgii_front/model/cls_producto.dart';
import 'package:sgii_front/service/serv_producto.dart';
import 'package:sgii_front/util/common/parse.dart';

class ItemFacturaNotaCredito extends DbObj {

  FacturaNotaCredito facturaNotaCredito;
  int cantidad;
  Producto producto;
  double precioUnitario;
  double total;
  int tipoTransac;

  ItemFacturaNotaCredito({
    required this.facturaNotaCredito,
    required this.cantidad,
    required this.producto,
    required this.precioUnitario,
    required this.total,
    required this.tipoTransac,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'ItemFacturaNotaCredito';
  }

  static Future<ItemFacturaNotaCredito> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int facturaNotaCredito_id = -1;
    int facturaNotaCredito_idApi = -1;
    int producto_id = -1;
    int producto_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> facturaNotaCredito_map = map['facturaNotaCredito'];
      facturaNotaCredito_id = Parse.getInt(facturaNotaCredito_map['id']);
      facturaNotaCredito_idApi = Parse.getInt(facturaNotaCredito_map['id']);
      
      Map<String, dynamic> producto_map = map['producto'];
      producto_id = Parse.getInt(producto_map['id']);
      producto_idApi = Parse.getInt(producto_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> facturaNotaCredito_map = map['facturaNotaCredito'];
      facturaNotaCredito_id = Parse.getInt(facturaNotaCredito_map['id']);
      facturaNotaCredito_idApi = Parse.getInt(facturaNotaCredito_map['idApi']);
      
      Map<String, dynamic> producto_map = map['producto'];
      producto_id = Parse.getInt(producto_map['id']);
      producto_idApi = Parse.getInt(producto_map['idApi']);
      
    }

    int cantidad = Parse.getInt(map['cantidad']);
    double precioUnitario = Parse.getDouble(map['precioUnitario']);
    double total = Parse.getDouble(map['total']);
    int tipoTransac = Parse.getInt(map['tipoTransac']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return ItemFacturaNotaCredito(
      facturaNotaCredito: await FacturaNotaCreditoService().directGetItemById(facturaNotaCredito_id, facturaNotaCredito_idApi),
      cantidad: cantidad,
      producto: await ProductoService().directGetItemById(producto_id, producto_idApi),
      precioUnitario: precioUnitario,
      total: total,
      tipoTransac: tipoTransac,
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int facturaNotaCredito_id = -1;
    int facturaNotaCredito_idApi = -1;
    int producto_id = -1;
    int producto_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> facturaNotaCredito_map = map['facturaNotaCredito'];
      facturaNotaCredito_id = Parse.getInt(facturaNotaCredito_map['id']);
      facturaNotaCredito_idApi = Parse.getInt(facturaNotaCredito_map['id']);
      
      Map<String, dynamic> producto_map = map['producto'];
      producto_id = Parse.getInt(producto_map['id']);
      producto_idApi = Parse.getInt(producto_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> facturaNotaCredito_map = map['facturaNotaCredito'];
      facturaNotaCredito_id = Parse.getInt(facturaNotaCredito_map['id']);
      facturaNotaCredito_idApi = Parse.getInt(facturaNotaCredito_map['idApi']);
      
      Map<String, dynamic> producto_map = map['producto'];
      producto_id = Parse.getInt(producto_map['id']);
      producto_idApi = Parse.getInt(producto_map['idApi']);
      
    }

      this.facturaNotaCredito = await FacturaNotaCreditoService().directGetItemById(facturaNotaCredito_id, facturaNotaCredito_idApi);
      this.cantidad = cantidad;
      this.producto = await ProductoService().directGetItemById(producto_id, producto_idApi);
      this.precioUnitario = precioUnitario;
      this.total = total;
      this.tipoTransac = tipoTransac;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'facturaNotaCredito': facturaNotaCredito.toMap(),
      'cantidad': cantidad,
      'producto': producto.toMap(),
      'precioUnitario': precioUnitario,
      'total': total,
      'tipoTransac': tipoTransac,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static ItemFacturaNotaCredito _empty = ItemFacturaNotaCredito(
    facturaNotaCredito: FacturaNotaCredito.empty(),
    cantidad : 0,
    producto: Producto.empty(),
    precioUnitario : 0,
    total : 0,
    tipoTransac : 0,
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static ItemFacturaNotaCredito empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return '${producto.nombre}: $cantidad * \$${precioUnitario.toStringAsFixed(2)} = ${cantidad*precioUnitario}';
  }
}
