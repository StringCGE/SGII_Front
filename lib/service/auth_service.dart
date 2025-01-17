import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sgii_front/model/auth/cls_usuario.dart';
import 'package:sgii_front/model/auth/session_data.dart';
import 'package:sgii_front/util/common/common_data_service.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  ClsSessionData? sessionData;


  late final http.Client _client;
  AuthService(){
    _client = http.Client();
  }
  Future<Result> login(String user, String psw) async {
    Uri url = Uri.parse('${CommonDataService.urlApi}/api/Auth');
    return loginUri(url, user, psw);
  }
  Future<Result> loginAdmin(String user, String psw) async {
    Uri url = Uri.parse('${CommonDataService.urlApi}/api/Auth/admin');
    return loginUri(url, user, psw);
  }
  Future<Result> loginUri(Uri url, String user, String psw) async {
    final body = jsonEncode({
      'user': user,
      'password': psw,
    });
    try {
      final response = await _client.post(
        url,
        headers: {
          'Cache-Control': 'no-cache',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String token = data['token'];
        sessionData = tokenToSessionData(token);
        saveSessionToken(token);
        return Result(success: true);
      } else {
        clearSessionToken();
        return Result(success: false, errror: 'Error ${response.statusCode}');
      }
    } catch (e) {
      clearSessionToken();
      return Result(success: false, errror: 'Error ${e.toString()}');
    }
  }
  void logOut(){
    sessionData = null;
  }
  static Future<void> saveSessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', token);
  }
  static Future<String?> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_token');
  }
  static Future<void> clearSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
  }


  static Future<void> saveRuta(String value) async {
    print("Ruta guarda ${value}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ruta', value);
  }
  static Future<String?> getRuta() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ruta');
  }
  static Future<void> clearRuta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ruta');
  }

  static ClsSessionData tokenToSessionData(String token){
    DateFormat formatDateTime = DateFormat('dd/MM/yyyy HH:mm:ss');
    final jwtDecode = JWT.decode(token);
    final Map<String, dynamic> payload = jwtDecode.payload;
    int id = int.parse(payload['Id']);
    int estado = int.parse(payload['estado']);
    int idPersReg = int.parse(payload['idPersReg']);
    String role = payload['role'];
    String urlFoto = Parse.getString(payload['urlFoto']);
    String email = payload['email'];
    String usuario = payload['usuario'];
    String nombre = payload['nombre'];
    String apellido = payload['apellido'];
    String nacimiento = payload['nacimiento'];
    DateTime dt = Parse.getDateTimeDF(formatDateTime, payload['dtReg']);
    String cedula = payload['cedula'];
    String jti = payload['jti'];
    int nbf = payload['nbf'];
    int exp = payload['exp'];
    int iat = payload['iat'];
    String iss = payload['iss'];
    String aud = payload['aud'];
    ClsUsuario usu = ClsUsuario(
      id: id,
      idApi: id,
      dtReg: dt,
      estado: estado,
      idPersReg: idPersReg,
      urlFoto: urlFoto,
      email: email,
      usuario: usuario,
      psw: "********",
      role: role,
      nombre: nombre,
      apellido: apellido,
      nacimiento: formatDateTime.parse(nacimiento),
      cedula: cedula,
    );
    return ClsSessionData(
      token: token,
      usuario: usu,
      jti: jti,
      nbf: Parse.timeSpam_To_DateTime(nbf),
      exp: Parse.timeSpam_To_DateTime(exp),
      iat: Parse.timeSpam_To_DateTime(iat),
      iss: iss,
      aud: aud,
    );
  }
}