import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/util/common/parse.dart';

class Proveedor extends DbObj {
  String razonSocial;
  String ruc;
  Persona responsable;
  String telefonoResponsable;
  String direccionMatriz;
  String telefono1;
  String telefono2;
  String email;

  Proveedor({
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
    required this.razonSocial,
    required this.ruc,
    required this.responsable,
    required this.telefonoResponsable,
    required this.direccionMatriz,
    required this.telefono1,
    required this.telefono2,
    required this.email,
  });

  @override
  String toString() {
    return 'Proveedor: Razón Social - $razonSocial, RUC - $ruc, Responsable - ${responsable.nombresApellidos()}, Tel. Responsable - $telefonoResponsable, Dirección - $direccionMatriz, Tel.1 - $telefono1, Tel.2 - $telefono2, Email - $email';
  }

  static Future<Proveedor> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = Parse.getInt(map['id']);
    int idApi = Parse.getInt(map['idApi']);

    int responsableId = -1;
    int responsableIdApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);
      responsableIdApi = Parse.getInt(map['responsable_id']);
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> responsableMap = map['responsable'];
      responsableId = Parse.getInt(responsableMap['id']);
      responsableIdApi = Parse.getInt(responsableMap['idApi']);
    }

    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    String razonSocial = map['razonSocial'] ?? '';
    String ruc = map['ruc'] ?? '';
    String telefonoResponsable = map['telefonoResponsable'] ?? '';
    String direccionMatriz = map['direccionMatriz'] ?? '';
    String telefono1 = map['telefono1'] ?? '';
    String telefono2 = map['telefono2'] ?? '';
    String email = map['email'] ?? '';

    return Proveedor(
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
      razonSocial: razonSocial,
      ruc: ruc,
      responsable: await PersonaService().directGetItemById(responsableId, responsableIdApi),
      telefonoResponsable: telefonoResponsable,
      direccionMatriz: direccionMatriz,
      telefono1: telefono1,
      telefono2: telefono2,
      email: email,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int responsableId = -1;
    int responsableIdApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);
      responsableIdApi = Parse.getInt(map['responsable_id']);
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> responsableMap = map['responsable'];
      responsableId = Parse.getInt(responsableMap['id']);
      responsableIdApi = Parse.getInt(responsableMap['idApi']);
    }

    dtReg = Parse.getDateTime(map['dtReg']);
    idPersReg = Parse.getInt(map['idPersReg']);
    estado = Parse.getInt(map['estado']);

    razonSocial = map['razonSocial'] ?? '';
    ruc = map['ruc'] ?? '';
    telefonoResponsable = map['telefonoResponsable'] ?? '';
    direccionMatriz = map['direccionMatriz'] ?? '';
    telefono1 = map['telefono1'] ?? '';
    telefono2 = map['telefono2'] ?? '';
    email = map['email'] ?? '';

    responsable = await PersonaService().directGetItemById(responsableId, responsableIdApi);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
      'razonSocial': razonSocial,
      'ruc': ruc,
      'responsable': responsable.toMap(),
      'telefonoResponsable': telefonoResponsable,
      'direccionMatriz': direccionMatriz,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'email': email,
    };
  }

  static final Proveedor _empty = Proveedor(
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // Estado para objeto vacío
    razonSocial: '',
    ruc: '',
    responsable: Persona.empty(),
    telefonoResponsable: '',
    direccionMatriz: '',
    telefono1: '',
    telefono2: '',
    email: '',
  );

  static Proveedor empty() {
    return _empty;
  }
}