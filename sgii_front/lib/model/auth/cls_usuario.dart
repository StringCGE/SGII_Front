import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/my_img.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:intl/intl.dart';

class ClsUsuario extends DbObj{

  MyImg? img;
  String urlFoto;
  String email;
  String usuario;
  String psw;
  String role;
  String nombre;
  String apellido;
  String cedula;
  DateTime nacimiento;

  ClsUsuario({
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
    required this.urlFoto,
    required this.email,
    required this.usuario,
    required this.psw,
    required this.role,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.nacimiento
  });

  static ClsUsuario fromMap(Map<String, dynamic> map) {
    DateFormat formatDateTime = DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime nacimiento = DateTime.parse(map['nacimiento']);
    return ClsUsuario(
      id: Parse.getInt(map['id']),
      idApi: Parse.getInt(map['idApi']),
      dtReg: Parse.getDateTimeDF(formatDateTime, map['dt_reg']),
      idPersReg: Parse.getInt(map['idPersReg']),
      estado: Parse.getInt(map['estado']),
      urlFoto: Parse.getString(map['urlFoto']),
      email: Parse.getString(map['email']),
      usuario: Parse.getString(map['identification']),
      psw: Parse.getString(map['psw']),
      role: Parse.getString(map['role']),
      nombre: Parse.getString(map['nombre']),
      apellido: Parse.getString(map['apellido']),
      cedula: Parse.getString(map['cedula']),
      nacimiento: nacimiento,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    DateFormat formatDateTime = DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime nacimiento = DateTime.parse(map['nacimiento']);
    this.id = Parse.getInt(map['id']);
    this.urlFoto = Parse.getString(map['urlFoto']);
    this.email = Parse.getString(map['email']);
    this.usuario = Parse.getString(map['usuario']);
    this.psw = Parse.getString(map['psw']);
    this.role = Parse.getString(map['role']);
    this.nombre = Parse.getString(map['nombre']);
    this.apellido = Parse.getString(map['apellido']);
    this.cedula = Parse.getString(map['cedula']);
    this.nacimiento = Parse.getDateTimeDF(formatDateTime ,map['nacimiento']);
  }

  @override
  Map<String, dynamic> toMap() {
    //String strGps = Parse.latLngToString(gps);
    /*if(gps != null){
      strGps = jsonEncode(gps!.toJson());
    }*/
    return {
      'id': id,
      'urlFoto': urlFoto,
      'email': email,
      'usuario': usuario,
      'psw': psw,
      'role': role,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'nacimiento': nacimiento
    };
  }

  Map<String, dynamic> toMapInsert() {
    //String strGps = Parse.latLngToString(gps);
    //strGps = jsonEncode(gps!.toJson());
    /*if(gps != null){
    }*/
    return {
      'urlFoto': urlFoto,
      'email': email,
      'usuario': usuario,
      'psw': psw,
      'role': role,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'nacimiento': nacimiento
    };
  }

  void agregarEtiqueta(String type){
    //etiquetas.add(ClsEtiqueta)
  }
}