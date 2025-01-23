import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor.dart';
import 'package:sgii_front/service/serv_emisor.dart';
import 'package:sgii_front/util/common/parse.dart';

class Producto extends DbObj {

  Emisor proveedor;
  String nombre;
  String detalle;
  double precio;
  int cantidad;

  Producto({
    required this.proveedor,
    required this.nombre,
    required this.detalle,
    required this.precio,
    required this.cantidad,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'Producto';
  }

  static Future<Producto> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int proveedor_id = -1;
    int proveedor_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> proveedor_map = map['proveedor'];
      proveedor_id = Parse.getInt(proveedor_map['id']);
      proveedor_idApi = Parse.getInt(proveedor_map['id']);

    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> proveedor_map = map['proveedor'];
      proveedor_id = Parse.getInt(proveedor_map['id']);
      proveedor_idApi = Parse.getInt(proveedor_map['idApi']);

    }

    String nombre = Parse.getString(map['nombre']);
    String detalle = Parse.getString(map['detalle']);
    double precio = Parse.getDouble(map['precio']);
    int cantidad = Parse.getInt(map['cantidad']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return Producto(
      proveedor: await EmisorService().directGetItemById(proveedor_id, proveedor_idApi),
      nombre: nombre,
      detalle: detalle,
      precio: precio,
      cantidad: cantidad,
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int proveedor_id = -1;
    int proveedor_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> proveedor_map = map['proveedor'];
      proveedor_id = Parse.getInt(proveedor_map['id']);
      proveedor_idApi = Parse.getInt(proveedor_map['id']);

    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> proveedor_map = map['proveedor'];
      proveedor_id = Parse.getInt(proveedor_map['id']);
      proveedor_idApi = Parse.getInt(proveedor_map['idApi']);

    }

      this.proveedor = await EmisorService().directGetItemById(proveedor_id, proveedor_idApi);
      this.nombre = nombre;
      this.detalle = detalle;
      this.precio = precio;
      this.cantidad = cantidad;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'proveedor': proveedor.toMap(),
      'nombre': nombre,
      'detalle': detalle,
      'precio': precio,
      'cantidad': cantidad,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static Producto _empty = Producto(
    proveedor: Emisor.empty(),
    nombre : '',
    detalle : '',
    precio : 0,
    cantidad : 0,
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static Producto empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return nombre;
  }

  double get valorTotal => precio * cantidad;

}
