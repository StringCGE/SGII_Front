import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor.dart';
import 'package:sgii_front/service/serv_emisor.dart';
import 'package:sgii_front/model/cls_emisor_establecimiento.dart';
import 'package:sgii_front/service/serv_emisor_establecimiento.dart';
import 'package:sgii_front/util/common/parse.dart';

class EmisorItem extends DbObj {

  Emisor emisor;
  EmisorEstablecimiento emisorEstablecimiento;
  String puntoEmision;

  EmisorItem({
    required this.emisor,
    required this.emisorEstablecimiento,
    required this.puntoEmision,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'EmisorItem';
  }

  static Future<EmisorItem> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int emisor_id = -1;
    int emisor_idApi = -1;
    int emisorEstablecimiento_id = -1;
    int emisorEstablecimiento_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['id']);
      
      Map<String, dynamic> emisorEstablecimiento_map = map['emisorEstablecimiento'];
      emisorEstablecimiento_id = Parse.getInt(emisorEstablecimiento_map['id']);
      emisorEstablecimiento_idApi = Parse.getInt(emisorEstablecimiento_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['idApi']);
      
      Map<String, dynamic> emisorEstablecimiento_map = map['emisorEstablecimiento'];
      emisorEstablecimiento_id = Parse.getInt(emisorEstablecimiento_map['id']);
      emisorEstablecimiento_idApi = Parse.getInt(emisorEstablecimiento_map['idApi']);
      
    }

    String puntoEmision = Parse.getString(map['puntoEmision']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return EmisorItem(
      emisor: await EmisorService().directGetItemById(emisor_id, emisor_idApi),
      emisorEstablecimiento: await EmisorEstablecimientoService().directGetItemById(emisorEstablecimiento_id, emisorEstablecimiento_idApi),
      puntoEmision: puntoEmision,
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
    int emisorEstablecimiento_id = -1;
    int emisorEstablecimiento_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['id']);
      
      Map<String, dynamic> emisorEstablecimiento_map = map['emisorEstablecimiento'];
      emisorEstablecimiento_id = Parse.getInt(emisorEstablecimiento_map['id']);
      emisorEstablecimiento_idApi = Parse.getInt(emisorEstablecimiento_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['idApi']);
      
      Map<String, dynamic> emisorEstablecimiento_map = map['emisorEstablecimiento'];
      emisorEstablecimiento_id = Parse.getInt(emisorEstablecimiento_map['id']);
      emisorEstablecimiento_idApi = Parse.getInt(emisorEstablecimiento_map['idApi']);
      
    }

      this.emisor = await EmisorService().directGetItemById(emisor_id, emisor_idApi);
      this.emisorEstablecimiento = await EmisorEstablecimientoService().directGetItemById(emisorEstablecimiento_id, emisorEstablecimiento_idApi);
      this.puntoEmision = puntoEmision;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'emisor': emisor.toMap(),
      'emisorEstablecimiento': emisorEstablecimiento.toMap(),
      'puntoEmision': puntoEmision,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static EmisorItem _empty = EmisorItem(
    emisor: Emisor.empty(),
    emisorEstablecimiento: EmisorEstablecimiento.empty(),
    puntoEmision : '',
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static EmisorItem empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return '${emisor.getValueStr()}  ${emisor.getValueStr()}';
  }
}
