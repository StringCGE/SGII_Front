import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_estado_civil.dart';
import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/model/cls_sexo.dart';
import 'package:sgii_front/model/cls_user.dart';
import 'package:sgii_front/service/create_user_service.dart';
import 'package:sgii_front/service/serv_user.dart';
import 'package:sgii_front/util/common/list_errror.dart';
import 'package:sgii_front/util/common/result.dart';

class CreateUserController{
  User user = User(
      persona: Persona.empty(),
      email: '',
      password: '',
      urlFoto: '',
      role: '',
      id: -1,
      idApi: -1,
      dtReg: DateTime.now(),
      idPersReg: 1,
      estado: -100
  );

  String rcEmailCode = "";
  String rcEmailValido = "";
  int rcTransaccionId = -1;
  int rcUsuarioId = -1;
  DateTime rcFecha = DateTime.now();



  void clear(){
    user.persona = Persona.empty();
    user.email = '';
    user.password = '';
    user.urlFoto = '';
    user.role = '';
    user.id = -1;
    user.idApi = -1;
    user.dtReg = DateTime.now();
    user.idPersReg = 1;
    user.estado = -100;
  }
  /*


   */

  Future<bool> usuarioExiste(String usuario) async {
    if (usuario != null && usuario != ""){
      Result res = await CreateUserService.existUser(usuario);
      if (res.success){
        return res.value;
      }
      return false;//throw res.errror;
    }
    return false;
  }
  Future<Result> creaUsuario() async {
    UserService userS = UserService();
    return await userS.createItem(user);
  }
  Future<ListErrror> pasoUno({
    required BuildContext context,
    required String email,
    required String psw,
    required String confPsw,
  }) async{
    /*this.usuario = usuario;
    this.email = email;
    this.psw = psw;*/


    ListErrror lErr = ListErrror();

    bool valida = true;
    final bool usuexist = await usuarioExiste(email);
    if (campoVacio(lErr,"email",email)){
      lErr.add(
          ErrrorNotify( name: "email",
            msg: "El email esta vacio",
          )
      );
      valida = false;
    }
    if (usuexist){
      lErr.add(
          ErrrorNotify( name: "email",
            msg: "El email $email ya existe",
          )
      );
      valida = false;
    }
    if (!campoVacio(lErr,"psw",psw) && psw != confPsw){
      lErr.add(
          ErrrorNotify( name: "confpsw",
            msg: "las contraseñas no coinciden",
          )
      );
      valida = false;
    }

    return lErr;
  }

  Future<ListErrror> pasoDos({
    required BuildContext context,
    required String nombre1,
    required String nombre2,
    required String apellido1,
    required String apellido2,
    required DateTime nacimiento,
  }) async{
    /*this.nombre = nombre;
    this.apellido = apellido;
    this.nacimiento = nacimiento;*/

    ListErrror lErrr = ListErrror();

    bool valida = true;


    campoVacio(lErrr,"nombre1",nombre1);
    campoVacio(lErrr,"nombre2",nombre2);
    campoVacio(lErrr,"apellido1",apellido1);
    campoVacio(lErrr,"apellido2",apellido2);


    return lErrr;
  }



  Future<ListErrror> pasoTres({
    required BuildContext context,
    required String cedula,
    required Sexo sexo,
    required EstadoCivil estadoCivil,
    required Nacionalidad nacionalidad,
    required String grupoSanguineo,
    required String tipoSanguineo
  }) async{
    /*this.nombre = nombre;
    this.apellido = apellido;
    this.nacimiento = nacimiento;*/

    ListErrror lErrr = ListErrror();

    bool valida = true;


    campoVacio(lErrr,"cedula", cedula);
    campoVacio(lErrr,"sexo",sexo.nombre);
    campoVacio(lErrr,"estadoCivil",estadoCivil.nombre);
    campoVacio(lErrr,"nacionalidad",nacionalidad.nombre);
    campoVacio(lErrr,"grupoSanguine",grupoSanguineo);
    campoVacio(lErrr,"tipoSanguineo",tipoSanguineo);

    if (!lErrr.haveErrror){
      Result r = await creaUsuario();
      if (!r.success){
        lErrr.add(
            ErrrorNotify( name: "creauser",
              msg: "Fallo la creacion de usuario",
            )
        );
      }
    }
    return lErrr;
  }



  bool campoVacio(ListErrror lErr,String name, String value){
    if (value == ""){
      lErr.add(
          ErrrorNotify( name: name,
            msg: "El campo no debe estar vacio",
          )
      );
      return true;
    }
    return false;
  }
}