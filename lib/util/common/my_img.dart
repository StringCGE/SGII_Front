import 'dart:io';
import 'package:flutter/foundation.dart';

class MyImg{
  String name = "";
  String webPath = "";
  String path = "";
  String strBin = "";
  Uint8List? bytes;
  List<int>? lByte;
  File? file;

  MyImg({
    required this.name,
    this.webPath = '',
    this.path = '',
    this.strBin = '',
    this.file = null,
  });

  bool existBytes(){
    return bytes != null;
  }

  bool existList(){
    if(lByte != null){
      return lByte!.isEmpty;
    }
    return false;
  }

  void clear(){
    this.name = '';
    this.webPath = '';
    this.path = '';
    this.strBin = '';
    this.bytes = null;
    this.lByte = null;
    this.file = null;
  }
}