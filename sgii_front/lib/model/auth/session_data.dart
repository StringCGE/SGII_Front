

import 'package:sgii_front/model/auth/cls_usuario.dart';
import 'package:sgii_front/model/cls_user.dart';

class ClsSessionData {
  final String token;

  User usuario;
  //Identificador unico de token
  final String jti;
  //not before token no valido hasta
  final DateTime nbf;
  final DateTime exp;
  //Issued At
  final DateTime iat;
  //Emisor del token
  final String iss;
  //Destinatarios esperados
  final String aud;
  ClsSessionData({
    required this.token,
    required this.usuario,
    required this.jti,
    required this.nbf,
    required this.exp,
    required this.iat,
    required this.iss,
    required this.aud,
  });

  User get use{
    return usuario;
  }
}