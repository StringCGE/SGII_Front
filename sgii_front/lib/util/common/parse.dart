import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Parse{
  static String truncateString(String text, int maxLength) {
    return text.length <= maxLength ? text : text.substring(0, maxLength) + '...';
  }
  static int getInt(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      final parsedValue = int.tryParse(value);
      if (parsedValue != null) {
        return parsedValue;
      }
    }
    return 0;
  }

  static double getDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      try{
        return double.parse(value);
      }catch(e){
        return 0;
      }
    }
    throw FormatException('Value is not a valid double: $value');
    //return 0.0;
  }

  static String getString(dynamic value){
    return (value!=null)?value:"";
  }
  static String getDateTimeToString(DateTime value) {
    DateFormat formatDateTime = DateFormat('dd/MM/yyyy HH:mm:ss');
    return getDateTimeToStringDF(formatDateTime, value);
  }
  static String getDateTimeToStringDF(DateFormat? formatDateTime, DateTime value) {
    if (formatDateTime != null) {
      return formatDateTime.format(value);
    } else {
      // Si no se pasa un formato, usamos el formato estándar de `DateTime.toString()`
      return value.toIso8601String();
    }
  }
  static String getDatetimeToStringFromQuery(DateTime value) {
    String formatted = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(value);
    return Uri.encodeComponent(formatted);
  }
  static DateTime getDateTime(dynamic value) {
    if (value != null) {
      if (value is DateTime) {
        return value;
      } else if (value is String) {
        DateTime? parsedDate;
        List<String> formats = [
          "yyyy-MM-ddTHH:mm:ss.SSS",  // Formato ISO con milisegundos
          "dd/MM/yyyy HH:mm:ss",      // Formato europeo tradicional
          "yyyy/MM/dd HH:mm:ss",      // Formato con barras
          "yyyy-MM-dd HH:mm:ss",      // Formato ISO sin T
        ];
        for (var format in formats) {
          try {
            parsedDate = DateFormat(format).parse(value);
            break;
          } catch (e) {
            continue;
          }
        }
        if (parsedDate != null) {
          return parsedDate;
        }
      }
    }
    return DateTime(1995, 4, 14);
  }
  static DateTime getDateTimeDF(DateFormat? formatDateTime, dynamic value){
    if (value!=null){
      if (value is DateTime) {
        return value;
      } else if (value is String) {
        if(formatDateTime != null) {
          return formatDateTime.parse(value);
        }else{
          return DateTime.parse(value);
        }
      }
    }
    return DateTime(1995,4,14);
  }
  static bool getBool(dynamic value){
    if (value!=null){
      if (value is int) {
        return value != 0;
      } else if (value is bool) {
        return value;
      }
    }
    return false;
  }
  static String latLngToString(LatLng? latLng) {
    if(latLng != null){
      return '${latLng.latitude},${latLng.longitude}';
    }
    return "";
  }
  static LatLng? stringToLatLng(String value) {
    if(value != ""){
      List<String> partes = value.split(',');
      double latitud = double.parse(partes[0]);
      double longitud = double.parse(partes[1]);
      return LatLng(latitud, longitud);
    }
    return null;
  }
  static int bool_to_int(bool value){
    return value?1:0;
  }
  static bool int_to_bool(int value){
    return value != 0;
  }
  static DateTime timeSpam_To_DateTime(int timestamp){
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  }

  static Future<String> getBlobContentAsString(String blobUrl) async {
    final response = await http.get(Uri.parse(blobUrl));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al obtener el blob');
    }
  }

  static Future<List<int>> getBlobContentAsBytes(String blobUrl) async {
    final response = await http.get(Uri.parse(blobUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error al obtener el blob');
    }
  }

  static String str_IntToString(int value) {
    return value.toString();
  }

  static String str_ColorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  static String str_BoolToString(bool value) {
    return value ? 'true' : 'false';
  }

  static int stringToInt(String? value) {
    return int.tryParse(value ?? '') ?? 0;
  }

  static double stringToDouble(String? value) {
    return double.tryParse(value ?? '') ?? 0.0;
  }

  static num stringToNum(String? value) {
    return num.tryParse(value ?? '') ?? 0;
  }
  static String boolToString(bool? value) {
    return value?.toString() ?? '';
  }
  static String intToString(int? value) {
    return value?.toString() ?? '';
  }

  static String doubleToString(double? value) {
    return value?.toString() ?? '';
  }

  static String numToString(num? value) {
    return value?.toString() ?? '';
  }

  static Color str_StringToColor(String value) {
    if (value.startsWith('#')) {
      value = value.substring(1);
    }
    if (value.length == 6) {
      value = 'FF$value';
    }
    final int colorInt = int.parse(value, radix: 16);
    return Color(colorInt);
  }

  static bool str_StringToBool(String value) {
    return value.toLowerCase() == 'true';
  }

  static dynamic str_stringToDynamic(String value, String type){
    if (value == ""){
      return null;
    }
    switch(type){
      case 'int': return stringToInt(value);
      case 'Color': return str_StringToColor(value);
      case 'bool': return str_StringToBool(value);
    }
    return null;
  }
  static String str_dynamicToString(dynamic value, String type){
    if (value == null){
      return "";
    }
    switch(type){
      case 'int': return str_IntToString(value);
      case 'Color': return str_ColorToString(value);
      case 'bool': return str_BoolToString(value);
    }
    return "";
  }
/*static String ToString(){
    return "";
  }
  static String ToString(){
    return "";
  }
  static String ToString(){
    return "";
  }*/
}