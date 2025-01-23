import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

class PublicoUsuarioUtil{

  static Map<String, String> map = {};

  static Future<String> getImgUrl(String value) async {
    if (map[value] != null){
      if (map[value]! != ""){
        return map[value]!;
      }
    }
    try{
      //final url = Uri.parse('${CommonDataService.urlApi}/api/Publicacion?Usuario=2&offset=$value');
      final url = Uri.parse('${Config.urlApi}/api/PublicoUsuarioUtil/UrlImage/${value}');
      final response = await http.get(
        url,
        headers: {
          'Cache-Control': 'no-cache',
          //'Authorization': 'Bearer $token',
          //'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        String url = jsonMap['result'];
        map[value] = url;
        return url;
      } else {
        return "";
      }
    }catch(e){
      return "";
    }
  }

  static Future<Result> validadorEnviarCodigoEmail({
    required String email
  }) async{
    final url = Uri.parse('${Config.urlApi}/api/PublicoUsuarioUtil/Validador/EnviarCodigoEmail');
    try {
      final response = await http.post(
          url,
          headers: {
            'Cache-Control': 'no-cache',
            //'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
          body:jsonEncode({
            'email': email,
          })
      );
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        bool success = data['success'];
        if(success){
          final Map<String, dynamic> result = data['result'];
          Result r = Result(success: true, value: result);
          return r;
        }else{
          String errror = data['error'];
          return Result(success: false, errror: 'Error ${errror}');
        }
        //return Result(success: true, value: user);
      } else {
        return Result(success: false, errror: 'Error ${response.statusCode}');
      }
    } catch (e) {
      return Result(success: false, errror: 'Error ${e.toString()}');
    }
  }

  static Future<Result> CambiarPsw({
    required String rcEmailCode,
    required String rcEmail,
    required String psw,
    required int rcTransaccionId,
    required int rcUsuarioId,
  }) async{
    final url = Uri.parse('${Config.urlApi}/api/PublicoUsuarioUtil/Validador/CambiarPsw');
    try {
      final response = await http.post(
          url,
          headers: {
            'Cache-Control': 'no-cache',
            //'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
          body:jsonEncode({
            'emailCode': rcEmailCode,
            'email': rcEmail,
            'transaccionId': rcTransaccionId,
            'usuarioId': rcUsuarioId,
            'psw': psw,
          })
      );
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        bool success = data['success'];
        if(success){
          Result r = Result(success: true, value: "");
          return r;
        }else{
          String errror = data['error'];
          return Result(success: false, errror: 'Error ${errror}');
        }
        //return Result(success: true, value: user);
      } else {
        return Result(success: false, errror: 'Error ${response.statusCode}');
      }
    } catch (e) {
      return Result(success: false, errror: 'Error ${e.toString()}');
    }
  }

  static Future<Result> recuperarPswEnviarCodigoEmail({
    required String email
  }) async{
    final url = Uri.parse('${Config.urlApi}/api/PublicoUsuarioUtil/Validador/RecuperarPswCodigoEmail');
    try {
      final response = await http.post(
          url,
          headers: {
            'Cache-Control': 'no-cache',
            //'accept': 'text/plain',
            'Content-Type': 'application/json',
          },
          body:jsonEncode({
            'email': email,
          })
      );
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        bool success = data['success'];
        if(success){
          final Map<String, dynamic> result = data['result'];
          Result r = Result(success: true, value: result);
          return r;
        }else{
          String errror = data['error'];
          return Result(success: false, errror: 'Error ${errror}');
        }
        //return Result(success: true, value: user);
      } else {
        return Result(success: false, errror: 'Error ${response.statusCode}');
      }
    } catch (e) {
      return Result(success: false, errror: 'Error ${e.toString()}');
    }
  }
}