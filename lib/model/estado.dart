import 'package:flutter/material.dart';
import 'package:sgii_front/controller/login_controller.dart';
import 'package:sgii_front/util/common/app_string.dart';
import 'package:sgii_front/util/common/app_style.dart';

class Estado{
  static Estado? _instance;
  Estado._internal() {
    /*if(kIsWeb){
      EstadoAndroid().initApp((val){

      });
    }*/
    //_initialize();
  }
  factory Estado() {
    return _instance ??= Estado._internal();
  }
  //InitState state = InitState.none;

  AppStyle appStyle = AppStyle();
  AppString appString = AppString();
  LoginController cLogin = LoginController();
  /*StorageController cStorage = StorageController();
  EstadoAndroid estAndroid = EstadoAndroid();*/


  int indexConf = 1;
  int indexConfigValue(){
    int i = indexConf;
    indexConf += 1;
    return i;
  }



  void inicializaRutas(){
    /*addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );
    addRoute("/", () => );*/
  }

  List<String> actualScreen = [];
  Widget actualWid = Text("");
  final Map<String, Widget Function()> routes = {};

  Function? cambioScreenCallback;

  void addRoute(String route, Widget Function() widgetBuilder) {
    if (!routes.containsKey(route)) {
      routes[route] = widgetBuilder;
    } else {
      //throw Exception("Route already exists");
    }
  }

  void setActual(String route) {
    if (routes.containsKey(route)) {
      actualWid = routes[route]!();
      if (cambioScreenCallback != null) {
        cambioScreenCallback!();
      }
    } else {
      throw Exception("CFM La ruta no existe");
    }
  }
  Widget? getActual(String? route) {
    if (route == null){
      print("get Ruta Actual ${route} => null");
      return null;
    }
    if (routes.containsKey(route)) {
      print("get Ruta Actual ${route} => rutea");
      return routes[route]!();
    } else {
      print("get Ruta Actual ${route} => null");
      return null;
    }
  }
  void setCambioScreen(Function callback) {
    cambioScreenCallback = callback;
  }



}