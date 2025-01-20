import 'package:sgii_front/model/cls_estado_civil.dart';
import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/model/cls_sexo.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_estado_civil.dart';
import 'package:sgii_front/service/serv_nacionalidad.dart';
import 'package:sgii_front/service/serv_sexo.dart';
import 'package:sgii_front/util/common/parse.dart';

class Persona extends DbObj {
  String nombre1;
  String nombre2;
  String apellido1;
  String apellido2;
  DateTime fechaNacimiento;
  String cedula;
  Sexo sexo; // "Masculino", "Femenino", "Otro"
  EstadoCivil estadoCivil; // "Soltero", "Casado", etc.
  Nacionalidad nacionalidad; // Ejemplo: "Ecuatoriana", "Mexicana"
  String grupoSanguineo; // Ejemplo: "O+", "A-", etc.
  String tipoSanguineo; // RH, puede ser "+" o "-"

  Persona({
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
    required this.nombre1,
    required this.nombre2,
    required this.apellido1,
    required this.apellido2,
    required this.fechaNacimiento,
    required this.cedula,
    required this.sexo,
    required this.estadoCivil,
    required this.nacionalidad,
    required this.grupoSanguineo,
    required this.tipoSanguineo,
  });

  String nombres(){
    return "$nombre1 $nombre2";
  }
  String apellidos(){
    return "$apellido1 $apellido2";
  }
  String nombresApellidos(){
    return "${nombres()} ${apellidos()}";
  }
  int calcularEdad() {
    final now = DateTime.now();
    int edad = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month || (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // Sobrescribir el método toString para una salida más legible y útil
  @override
  String toString() {
    return 'Persona: $nombre1 $nombre2 $apellido1 $apellido2, Fecha de Nacimiento: $fechaNacimiento, Edad: ${calcularEdad()} años, Cédula: $cedula, Sexo: $sexo, Estado Civil: $estadoCivil, Nacionalidad: $nacionalidad, Grupo Sanguíneo: $grupoSanguineo, Tipo RH: $tipoSanguineo';
  }

  static Future<Persona> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;

    int sexo_id = -1;
    int estadoCivil_id = -1;
    int nacionalidad_id = -1;
    int sexo_idApi = -1;
    int estadoCivil_idApi = -1;
    int nacionalidad_idApi = -1;

    if(fromApi){
      idApi = Parse.getInt(map['id']);
/*
        sexo_idApi = Parse.getInt(map['sexo_id']);
        estadoCivil_idApi = Parse.getInt(map['estadoCivil_id']);
        nacionalidad_idApi = Parse.getInt(map['nacionalidad_id']);*/
      Map<String, dynamic> sexo_map = map['sexo'];
      sexo_id = Parse.getInt(sexo_map['id']);
      sexo_idApi = Parse.getInt(sexo_map['id']);

      Map<String, dynamic> estadoCivil_map = map['estadoCivil'];
      estadoCivil_id = Parse.getInt(estadoCivil_map['id']);
      estadoCivil_idApi = Parse.getInt(estadoCivil_map['id']);

      Map<String, dynamic> nacionalidad_map = map['nacionalidad'];
      nacionalidad_id = Parse.getInt(nacionalidad_map['id']);
      nacionalidad_idApi = Parse.getInt(nacionalidad_map['id']);
    }else{
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> sexo_map = map['mod_sexo'];
      sexo_id = Parse.getInt(sexo_map['id']);
      sexo_idApi = Parse.getInt(sexo_map['idApi']);

      Map<String, dynamic> estadoCivil_map = map['estadoCivil'];
      estadoCivil_id = Parse.getInt(estadoCivil_map['id']);
      estadoCivil_idApi = Parse.getInt(estadoCivil_map['idApi']);

      Map<String, dynamic> nacionalidad_map = map['mod_nacionalidad'];
      nacionalidad_id = Parse.getInt(nacionalidad_map['id']);
      nacionalidad_idApi = Parse.getInt(nacionalidad_map['idApi']);
    }

    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    String nombre1 = Parse.getString(map['nombre1']);
    String nombre2 = Parse.getString(map['nombre2']);
    String apellido1 = Parse.getString(map['apellido1']);
    String apellido2 = Parse.getString(map['apellido2']);
    DateTime fechaNacimiento = DateTime.parse(map['fechaNacimiento']);
    String cedula = Parse.getString(map['cedula']);

    String grupoSanguineo = Parse.getString(map['grupoSanguineo']);
    String tipoSanguineo = Parse.getString(map['tipoSanguineo']);

    return Persona(
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
      nombre1: nombre1,
      nombre2: nombre2,
      apellido1: apellido1,
      apellido2: apellido2,
      fechaNacimiento: fechaNacimiento,
      cedula: cedula,
      sexo: await SexoService().directGetItemById(sexo_id, sexo_idApi),
      estadoCivil: await EstadoCivilService().directGetItemById(estadoCivil_id, estadoCivil_idApi),
      nacionalidad: await NacionalidadService().directGetItemById(nacionalidad_id, nacionalidad_idApi),
      grupoSanguineo: grupoSanguineo,
      tipoSanguineo: tipoSanguineo,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {

    int sexo_id = -1;
    int estadoCivil_id = -1;
    int nacionalidad_id = -1;
    int sexo_idApi = -1;
    int estadoCivil_idApi = -1;
    int nacionalidad_idApi = -1;

    if(fromApi){
      idApi = Parse.getInt(map['id']);

      /*sexo_idApi = Parse.getInt(map['sexo_id']);
      estadoCivil_idApi = Parse.getInt(map['estadoCivil_id']);
      nacionalidad_idApi = Parse.getInt(map['nacionalidad_id']);*/
      Map<String, dynamic> sexo_map = map['mod_sexo'];
      sexo_id = Parse.getInt(sexo_map['id']);
      sexo_idApi = Parse.getInt(sexo_map['id']);

      Map<String, dynamic> estadoCivil_map = map['estadoCivil'];
      estadoCivil_id = Parse.getInt(estadoCivil_map['id']);
      estadoCivil_idApi = Parse.getInt(estadoCivil_map['id']);

      Map<String, dynamic> nacionalidad_map = map['mod_nacionalidad'];
      nacionalidad_id = Parse.getInt(nacionalidad_map['id']);
      nacionalidad_idApi = Parse.getInt(nacionalidad_map['id']);
    }else{
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> sexo_map = map['mod_sexo'];
      sexo_id = Parse.getInt(sexo_map['id']);
      sexo_idApi = Parse.getInt(sexo_map['idApi']);

      Map<String, dynamic> estadoCivil_map = map['estadoCivil'];
      estadoCivil_id = Parse.getInt(estadoCivil_map['id']);
      estadoCivil_idApi = Parse.getInt(estadoCivil_map['idApi']);

      Map<String, dynamic> nacionalidad_map = map['mod_nacionalidad'];
      nacionalidad_id = Parse.getInt(nacionalidad_map['id']);
      nacionalidad_idApi = Parse.getInt(nacionalidad_map['idApi']);
    }

    dtReg = Parse.getDateTime(map['dtReg']);
    idPersReg = Parse.getInt(map['idPersReg']);
    estado = Parse.getInt(map['estado']);

    nombre1 = Parse.getString(map['nombre1']);
    nombre2 = Parse.getString(map['nombre2']);
    apellido1 = Parse.getString(map['apellido1']);
    apellido2 = Parse.getString(map['apellido2']);
    fechaNacimiento = DateTime.parse(map['fechaNacimiento']);
    cedula = Parse.getString(map['cedula']);
    sexo = await SexoService().directGetItemById(sexo_id, sexo_idApi);
    estadoCivil = await EstadoCivilService().directGetItemById(estadoCivil_id, estadoCivil_idApi);
    nacionalidad = await NacionalidadService().directGetItemById(nacionalidad_id, nacionalidad_idApi);
    grupoSanguineo = Parse.getString(map['grupoSanguineo']);
    tipoSanguineo = Parse.getString(map['tipoSanguineo']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
      'nombre1': nombre1,
      'nombre2': nombre2,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'cedula': cedula,
      'sexo': sexo.toMap(),
      'estadoCivil': estadoCivil.toMap(),
      'nacionalidad': nacionalidad.toMap(),
      'grupoSanguineo': grupoSanguineo,
      'tipoSanguineo': tipoSanguineo,
    };
  }

  static final Persona _empty = Persona(
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995,04,14,12,34,56,7890),
    idPersReg: 1,
    estado: -100,
    nombre1: 'empty',
    nombre2: 'empty',
    apellido1: 'empty',
    apellido2: 'empty',
    fechaNacimiento: DateTime(1995,04,14,12,34,56,7890),
    cedula: '0000000000',
    sexo: Sexo.empty(),
    estadoCivil: EstadoCivil.empty(),
    nacionalidad: Nacionalidad.empty(),
    grupoSanguineo: 'O',
    tipoSanguineo: '+',
  );

  static Persona empty(){
    return _empty;
  }

  @override
  String getValueStr(){
    return nombresApellidos();
  }
}