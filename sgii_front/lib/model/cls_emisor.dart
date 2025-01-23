import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/util/common/parse.dart';

class Emisor extends DbObj {

  String razonSocial;
  String ruc;
  Persona responsable;
  String telefonoResponsable;
  String direccionMatriz;
  String telefono1;
  String telefono2;
  String email;

  Emisor({
    required this.razonSocial,
    required this.ruc,
    required this.responsable,
    required this.telefonoResponsable,
    required this.direccionMatriz,
    required this.telefono1,
    required this.telefono2,
    required this.email,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'Emisor';
  }

  static Future<Emisor> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int responsable_id = -1;
    int responsable_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> responsable_map = map['responsable'];
      responsable_id = Parse.getInt(responsable_map['id']);
      responsable_idApi = Parse.getInt(responsable_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> responsable_map = map['responsable'];
      responsable_id = Parse.getInt(responsable_map['id']);
      responsable_idApi = Parse.getInt(responsable_map['idApi']);
      
    }

    String razonSocial = Parse.getString(map['razonSocial']);
    String ruc = Parse.getString(map['ruc']);
    String telefonoResponsable = Parse.getString(map['telefonoResponsable']);
    String direccionMatriz = Parse.getString(map['direccionMatriz']);
    String telefono1 = Parse.getString(map['telefono1']);
    String telefono2 = Parse.getString(map['telefono2']);
    String email = Parse.getString(map['email']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return Emisor(
      razonSocial: razonSocial,
      ruc: ruc,
      responsable: await PersonaService().directGetItemById(responsable_id, responsable_idApi),
      telefonoResponsable: telefonoResponsable,
      direccionMatriz: direccionMatriz,
      telefono1: telefono1,
      telefono2: telefono2,
      email: email,
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int responsable_id = -1;
    int responsable_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> responsable_map = map['responsable'];
      responsable_id = Parse.getInt(responsable_map['id']);
      responsable_idApi = Parse.getInt(responsable_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> responsable_map = map['responsable'];
      responsable_id = Parse.getInt(responsable_map['id']);
      responsable_idApi = Parse.getInt(responsable_map['idApi']);
      
    }

      this.razonSocial = razonSocial;
      this.ruc = ruc;
      this.responsable = await PersonaService().directGetItemById(responsable_id, responsable_idApi);
      this.telefonoResponsable = telefonoResponsable;
      this.direccionMatriz = direccionMatriz;
      this.telefono1 = telefono1;
      this.telefono2 = telefono2;
      this.email = email;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'razonSocial': razonSocial,
      'ruc': ruc,
      'responsable': responsable.toMap(),
      'telefonoResponsable': telefonoResponsable,
      'direccionMatriz': direccionMatriz,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'email': email,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static Emisor _empty = Emisor(
    razonSocial : '',
    ruc : '',
    responsable: Persona.empty(),
    telefonoResponsable : '',
    direccionMatriz : '',
    telefono1 : '',
    telefono2 : '',
    email : '',
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static Emisor empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return razonSocial;
  }
}
