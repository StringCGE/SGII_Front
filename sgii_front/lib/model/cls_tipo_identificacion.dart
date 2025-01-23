import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/service/serv_nacionalidad.dart';
import 'package:sgii_front/util/common/parse.dart';

class TipoIdentificacion extends DbObj {

  String nombre;
  String detalle;
  Nacionalidad pais;

  TipoIdentificacion({
    required this.nombre,
    required this.detalle,
    required this.pais,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'TipoIdentificacion';
  }

  static Future<TipoIdentificacion> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int pais_id = -1;
    int pais_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> pais_map = map['pais'];
      pais_id = Parse.getInt(pais_map['id']);
      pais_idApi = Parse.getInt(pais_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> pais_map = map['pais'];
      pais_id = Parse.getInt(pais_map['id']);
      pais_idApi = Parse.getInt(pais_map['idApi']);
      
    }

    String nombre = Parse.getString(map['nombre']);
    String detalle = Parse.getString(map['detalle']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return TipoIdentificacion(
      nombre: nombre,
      detalle: detalle,
      pais: await NacionalidadService().directGetItemById(pais_id, pais_idApi),
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int pais_id = -1;
    int pais_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> pais_map = map['pais'];
      pais_id = Parse.getInt(pais_map['id']);
      pais_idApi = Parse.getInt(pais_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> pais_map = map['pais'];
      pais_id = Parse.getInt(pais_map['id']);
      pais_idApi = Parse.getInt(pais_map['idApi']);
      
    }

      this.nombre = nombre;
      this.detalle = detalle;
      this.pais = await NacionalidadService().directGetItemById(pais_id, pais_idApi);
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'detalle': detalle,
      'pais': pais.toMap(),
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static TipoIdentificacion _empty = TipoIdentificacion(
    nombre : '',
    detalle : '',
    pais: Nacionalidad.empty(),
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static TipoIdentificacion empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return '$nombre ${pais.getValueStr()}';
  }
}
