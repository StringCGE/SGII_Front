import 'package:sgii_front/util/common/result.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sgii_front/util/my_widget/config.dart';

class CreateUserService{
  static Future<Result> existUser(String userName) async{
    final url = Uri.parse('${Config.urlApi}/api/AppUsuario/UserNameExist/$userName');
    try {
      final response = await http.get(
        url,
        headers: {
          'Cache-Control': 'no-cache',
          'accept': 'text/plain',
          //'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        bool value = data['result'];
        return Result(success: true, value: value);
      } else {
        return Result(success: false, errror: 'Error ${response.statusCode}');
      }
    } catch (e) {
      return Result(success: false, errror: 'Error ${e.toString()}');
    }
  }

  /*


   */

  static Future<Result> createUser({
    required String usuario,
    required String email,
    required String psw,
    required String nombre,
    required String apellido,
    required DateTime nacimiento
  }) async{
    final url = Uri.parse('${Config.urlApi}/api/AppUsuario');
    try {
      final response = await http.post(
          url,
          headers: {
            'Cache-Control': 'no-cache',
            //'accept': '*/*',
            //'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body:jsonEncode({
            'identification': usuario,
            'email': email,
            'password': psw,
            'nombre': nombre,
            'apellido': apellido,
            'cedula': "000",
            'nacimiento': nacimiento.toIso8601String(),
          })
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> user = data['result'];
        return Result(success: true, value: user);
      } else {
        return Result(success: false, errror: 'Error ${response.statusCode}');
      }
    } catch (e) {
      return Result(success: false, errror: 'Error ${e.toString()}');
    }
  }
}