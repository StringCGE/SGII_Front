import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/model/cls_tipo_identificacion.dart';
import 'package:sgii_front/service/serv_tipo_identificacion.dart';
import 'package:sgii_front/util/common/parse.dart';

class Cliente extends DbObj {

  Persona persona;
  String identificacion;
  TipoIdentificacion tipoIdentificacion;
  String telefono;

  Cliente({
    required this.persona,
    required this.identificacion,
    required this.tipoIdentificacion,
    required this.telefono,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'Cliente';
  }

  static Future<Cliente> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int persona_id = -1;
    int persona_idApi = -1;
    int tipoIdentificacion_id = -1;
    int tipoIdentificacion_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['id']);
      
      Map<String, dynamic> tipoIdentificacion_map = map['tipoIdentificacion'];
      tipoIdentificacion_id = Parse.getInt(tipoIdentificacion_map['id']);
      tipoIdentificacion_idApi = Parse.getInt(tipoIdentificacion_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['idApi']);
      
      Map<String, dynamic> tipoIdentificacion_map = map['tipoIdentificacion'];
      tipoIdentificacion_id = Parse.getInt(tipoIdentificacion_map['id']);
      tipoIdentificacion_idApi = Parse.getInt(tipoIdentificacion_map['idApi']);
      
    }

    String identificacion = Parse.getString(map['identificacion']);
    String telefono = Parse.getString(map['telefono']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return Cliente(
      persona: await PersonaService().directGetItemById(persona_id, persona_idApi),
      identificacion: identificacion,
      tipoIdentificacion: await TipoIdentificacionService().directGetItemById(tipoIdentificacion_id, tipoIdentificacion_idApi),
      telefono: telefono,
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int persona_id = -1;
    int persona_idApi = -1;
    int tipoIdentificacion_id = -1;
    int tipoIdentificacion_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['id']);
      
      Map<String, dynamic> tipoIdentificacion_map = map['tipoIdentificacion'];
      tipoIdentificacion_id = Parse.getInt(tipoIdentificacion_map['id']);
      tipoIdentificacion_idApi = Parse.getInt(tipoIdentificacion_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['idApi']);
      
      Map<String, dynamic> tipoIdentificacion_map = map['tipoIdentificacion'];
      tipoIdentificacion_id = Parse.getInt(tipoIdentificacion_map['id']);
      tipoIdentificacion_idApi = Parse.getInt(tipoIdentificacion_map['idApi']);
      
    }

      this.persona = await PersonaService().directGetItemById(persona_id, persona_idApi);
      this.identificacion = identificacion;
      this.tipoIdentificacion = await TipoIdentificacionService().directGetItemById(tipoIdentificacion_id, tipoIdentificacion_idApi);
      this.telefono = telefono;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'persona': persona.toMap(),
      'identificacion': identificacion,
      'tipoIdentificacion': tipoIdentificacion.toMap(),
      'telefono': telefono,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static Cliente _empty = Cliente(
    persona: Persona.empty(),
    identificacion : '',
    tipoIdentificacion: TipoIdentificacion.empty(),
    telefono : '',
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static Cliente empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return persona.getValueStr();
  }
}
