
import 'package:flutter/material.dart';
import 'package:sgii_front/model/auth/session_data.dart';
import 'package:sgii_front/service/auth_service.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/loading_overlay.dart';
import 'package:sgii_front/util/common/result.dart';

class LoginController{
  ClsSessionData? get sessionData => sAuth.sessionData;
  set sessionData(ClsSessionData? value) => sAuth.sessionData = value;
  LoadingOverlay? cargando;
  AuthService sAuth = AuthService();
  Future<void> login({
    required BuildContext context,
    required String user,
    required String psw,
    required void Function() onLogin,
  }) async{
    if (cargando == null){
      cargando = LoadingOverlay(context);
    }
    cargando!.show();
    Result r = await sAuth.login(user, psw);
    if (r.success){
      onLogin();
    }else{
      Info info = Info();
      info.showErrorDialog(context, "Inicio de sesion fallido");
      //Info.toastFlotante("algo falta de completar o esta mal puesto");
      //Util.toastFlotante("Ah fallado el inicio de sesion");
      //Util.toastBarraAbajo(context, "Fallo el inicio de sesion");
      /*MsgDialog(
          title: 'Error',
          msg: '',
          icon: Icon(Icons.error)
      );*/
    }
    cargando!.hide();
  }

  Future<void> loginAdmin({
    required BuildContext context,
    required String user,
    required String psw,
    required void Function() onLogin,
  }) async{
    if (cargando == null){
      cargando = LoadingOverlay(context);
    }
    cargando!.show();
    Result r = await sAuth.loginAdmin(user, psw);
    if (r.success){
      onLogin();
    }else{
      Info info = Info();
      info.showErrorDialog(context, "Inicio de sesion fallido");
      /*MsgDialog(
        title: Estado().appString.loginFailureTitle,
        msg: Estado().appString.loginFailureMsg,
        icon: Icon(Icons.error),
      );*/
    }
    cargando!.hide();
  }
  Future<void> logOut() async{
    sAuth.logOut();
  }

}