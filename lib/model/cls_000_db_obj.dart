import 'package:sgii_front/util/common/parse.dart';

class DbObj {
  int id; // ID local para el objeto (offline)
  int idApi; // ID del objeto en el back-end (servidor centralizado)
  DateTime dtReg; // Fecha y hora de registro del objeto en el sistema (offline o sincronizado)
  int idPersReg; // ID de la persona que registra otro elemento
  int estado;//0 eliminado, 1 Creado
  int local = 0;
  //0 no es local
  //1 creado localmente
  //2 modificado localmente

  DbObj({
    required this.id,
    required this.idApi,
    required this.dtReg,
    required this.idPersReg,
    required this.estado,
  });

  static Future<DbObj> fromMap(Map<String, dynamic> map, bool fromApi) async {
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

    dynamic ob = map['ob'];
    return DbObj(
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
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
  }
  static final DbObj _empty = DbObj(
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995,04,14,12,34,56,7890),
    idPersReg: 1,
    estado: -100,//Estado de objeto vacio
  );

  static DbObj empty(){
    return _empty;
  }

  static DbObj id_idApi(int id, int idApi){
    return DbObj(
      id: id,
      idApi: idApi,
      dtReg: DateTime(1995,04,14,12,34,56,7890),
      idPersReg: -1,
      estado: -1,
    );
  }

  String getValueStr(){
    return "Hola que hace";
  }
}