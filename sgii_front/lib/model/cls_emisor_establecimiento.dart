import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor.dart';
import 'package:sgii_front/service/serv_emisor.dart';
import 'package:sgii_front/util/common/parse.dart';

class EmisorEstablecimiento extends DbObj {

  Emisor emisor;
  int numero;
  String nombre;
  String direccion;
  String puntosDeEmision;

  EmisorEstablecimiento({
    required this.emisor,
    required this.numero,
    required this.nombre,
    required this.direccion,
    required this.puntosDeEmision,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'EmisorEstablecimiento';
  }

  static Future<EmisorEstablecimiento> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int emisor_id = -1;
    int emisor_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['idApi']);
      
    }

    int numero = Parse.getInt(map['numero']);
    String nombre = Parse.getString(map['nombre']);
    String direccion = Parse.getString(map['direccion']);
    String puntosDeEmision = Parse.getString(map['puntosDeEmision']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return EmisorEstablecimiento(
      emisor: await EmisorService().directGetItemById(emisor_id, emisor_idApi),
      numero: numero,
      nombre: nombre,
      direccion: direccion,
      puntosDeEmision: puntosDeEmision,
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int emisor_id = -1;
    int emisor_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['idApi']);
      
    }

      this.emisor = await EmisorService().directGetItemById(emisor_id, emisor_idApi);
      this.numero = numero;
      this.nombre = nombre;
      this.direccion = direccion;
      this.puntosDeEmision = puntosDeEmision;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'emisor': emisor.toMap(),
      'numero': numero,
      'nombre': nombre,
      'direccion': direccion,
      'puntosDeEmision': puntosDeEmision,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static EmisorEstablecimiento _empty = EmisorEstablecimiento(
    emisor: Emisor.empty(),
    numero : 0,
    nombre : '',
    direccion : '',
    puntosDeEmision : '',
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static EmisorEstablecimiento empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return direccion;
  }
}
