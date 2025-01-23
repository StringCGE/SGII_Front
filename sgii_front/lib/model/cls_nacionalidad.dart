import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/parse.dart';

class Nacionalidad extends DbObj {
  String nombre;

  Nacionalidad({
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
    required this.nombre,
  });

  @override
  String toString() {
    return 'Nacionalidad: $nombre';
  }

  String getValue(){
    return '$nombre';
  }

  static Future<Nacionalidad> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    if(fromApi){
      idApi = Parse.getInt(map['id']);
    }else{
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);
    }
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    String nombre = Parse.getString(map['nombre']);

    return Nacionalidad(
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
      nombre: nombre,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    if(fromApi){
      idApi = Parse.getInt(map['id']);
    }else{
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);
    }
    dtReg = Parse.getDateTime(map['dtReg']);
    idPersReg = Parse.getInt(map['idPersReg']);
    estado = Parse.getInt(map['estado']);

    nombre = Parse.getString(map['nombre']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
      'nombre': nombre,
    };
  }

  static final Nacionalidad _empty = Nacionalidad(
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995,04,14,12,34,56,7890),
    idPersReg: 1,
    estado: -100,//Estado de objeto vacio
    nombre: 'empty',
  );

  static Nacionalidad empty(){
    return _empty;
  }

  static Nacionalidad id_idApi(int id, int idApi){
    return Nacionalidad(
      id: id,
      idApi: idApi,
      dtReg: DateTime(1995,04,14,12,34,56,7890),
      idPersReg: -1,
      estado: -1,
      nombre: '',
    );
  }

  @override
  String getValueStr(){
    return nombre;
  }
}