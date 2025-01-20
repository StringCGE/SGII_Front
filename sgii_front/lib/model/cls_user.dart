import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/util/common/parse.dart';

class User extends DbObj {

  Persona persona;
  String email;
  String password;
  String urlFoto;
  String role;

  User({
    required this.persona,
    required this.email,
    required this.password,
    required this.urlFoto,
    required this.role,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'User';
  }

  static Future<User> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int persona_id = -1;
    int persona_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['idApi']);
      
    }

    String email = Parse.getString(map['email']);
    String password = Parse.getString(map['password']);
    String urlFoto = Parse.getString(map['urlFoto']);
    String role = Parse.getString(map['role']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return User(
      persona: await PersonaService().directGetItemById(persona_id, persona_idApi),
      email: email,
      password: password,
      urlFoto: urlFoto,
      role: role,
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


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> persona_map = map['persona'];
      persona_id = Parse.getInt(persona_map['id']);
      persona_idApi = Parse.getInt(persona_map['idApi']);
      
    }

      this.persona = await PersonaService().directGetItemById(persona_id, persona_idApi);
      this.email = email;
      this.password = password;
      this.urlFoto = urlFoto;
      this.role = role;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'persona': persona.toMap(),
      'email': email,
      'password': password,
      'urlFoto': urlFoto,
      'role': role,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static User _empty = User(
    persona: Persona.empty(),
    email : '',
    password : '',
    urlFoto : '',
    role : '',
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static User empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    return persona.nombresApellidos();
  }
}
