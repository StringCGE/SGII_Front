import 'package:sgii_front/model/cls_000_db_obj.dart';

import 'package:sgii_front/util/common/parse.dart';

class RegistroDoc extends DbObj {

  String secuencial;
  String razonSocial;
  String identificacion;
  String fechaEmision;
  String numeroGuiaRemision;
  String codigoNumerico;
  String verificador;
  int denomComproModif;
  String numComproModif;
  int comproModif;

  RegistroDoc({
    required this.secuencial,
    required this.razonSocial,
    required this.identificacion,
    required this.fechaEmision,
    required this.numeroGuiaRemision,
    required this.codigoNumerico,
    required this.verificador,
    required this.denomComproModif,
    required this.numComproModif,
    required this.comproModif,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'RegistroDoc';
  }

  static Future<RegistroDoc> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;


    if (fromApi) {
      idApi = Parse.getInt(map['id']);


    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);


    }

    String secuencial = Parse.getString(map['secuencial']);
    String razonSocial = Parse.getString(map['razonSocial']);
    String identificacion = Parse.getString(map['identificacion']);
    String fechaEmision = Parse.getString(map['fechaEmision']);
    String numeroGuiaRemision = Parse.getString(map['numeroGuiaRemision']);
    String codigoNumerico = Parse.getString(map['codigoNumerico']);
    String verificador = Parse.getString(map['verificador']);
    int denomComproModif = Parse.getInt(map['denomComproModif']);
    String numComproModif = Parse.getString(map['numComproModif']);
    int comproModif = Parse.getInt(map['comproModif']);
    //DateTime? dtReg = map['dtReg'] != null
    //? DateTime.parse(map['dtReg'])
    //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    return RegistroDoc(
      secuencial: secuencial,
      razonSocial: razonSocial,
      identificacion: identificacion,
      fechaEmision: fechaEmision,
      numeroGuiaRemision: numeroGuiaRemision,
      codigoNumerico: codigoNumerico,
      verificador: verificador,
      denomComproModif: denomComproModif,
      numComproModif: numComproModif,
      comproModif: comproModif,
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {



    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);


    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);


    }

    this.secuencial = secuencial;
    this.razonSocial = razonSocial;
    this.identificacion = identificacion;
    this.fechaEmision = fechaEmision;
    this.numeroGuiaRemision = numeroGuiaRemision;
    this.codigoNumerico = codigoNumerico;
    this.verificador = verificador;
    this.denomComproModif = denomComproModif;
    this.numComproModif = numComproModif;
    this.comproModif = comproModif;
    this.dtReg = dtReg;
    this.idPersReg = idPersReg;
    this.estado = estado;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'secuencial': secuencial,
      'razonSocial': razonSocial,
      'identificacion': identificacion,
      'fechaEmision': fechaEmision,
      'numeroGuiaRemision': numeroGuiaRemision,
      'codigoNumerico': codigoNumerico,
      'verificador': verificador,
      'denomComproModif': denomComproModif,
      'numComproModif': numComproModif,
      'comproModif': comproModif,
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static RegistroDoc _empty = RegistroDoc(
    secuencial : '',
    razonSocial : '',
    identificacion : '',
    fechaEmision : '',
    numeroGuiaRemision : '',
    codigoNumerico : '',
    verificador : '',
    denomComproModif : 0,
    numComproModif : '',
    comproModif : 0,
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static RegistroDoc empty() {
    return _empty;
  }

  @override
  String getValueStr(){
    return '$razonSocial ${fechaEmision.toString()}';
  }
}
