import 'package:flutter/material.dart';
import 'package:sgii_front/model/estado.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/list_errror.dart';
import 'package:sgii_front/util/common/loading_overlay.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/validador_controller.dart';
import 'package:sgii_front/util/my_widget/campos_widget.dart';
import 'package:sgii_front/view/mod_user/flow_crear_usuario/flow_02_crear_usuario_widget.dart';

class Flow01CrearUsuarioWidget extends StatefulWidget{
  const Flow01CrearUsuarioWidget({
    super.key
  });
  @override
  Flow01CrearUsuarioWidgetState createState() => Flow01CrearUsuarioWidgetState();

}

class Flow01CrearUsuarioWidgetState extends State<Flow01CrearUsuarioWidget>{
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPsw = TextEditingController();
  TextEditingController tecConfPsw = TextEditingController();
  ValidadorController vcEmail = ValidadorController();
  ValidadorController vcPsw = ValidadorController();
  late ListErrror le;
  late LoadingOverlay cargando;
  void safeSetState(){
    if (mounted) setState(() {});
  }
  @override
  void initState(){
    super.initState();
    Estado().cuc.clear();
    le = ListErrror();
    cargando = LoadingOverlay(context);
  }

  @override
  Widget build(BuildContext context){
    return Material(
        child:Scaffold(
          body:SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 36, horizontal: 48),
              height: MediaQuery.of(context).size.height, // Aprovecha toda la altura disponible
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: partesInternas(),
                ),
              ),
            ),
          ),
        )
    );
  }
  String emailValido = "";
  List<Widget> partesInternas(){
    Color colorCampo = Color.fromARGB(255, 232, 182, 132);
    Color colorButton = Color.fromARGB(255, 212, 162, 112);
    double sep = 20;
    return <Widget>[
      EmailCodeValidator(
        controller: tecEmail,
        nombre: 'Correo electronico',
        placeholder: 'Email',
        backColor: colorCampo,
        buttonColor: colorButton,
        vcEmail: vcEmail,
        emailValido: (String email){
          emailValido = email;
        },
        err: le.find("email"),
      ),
      SizedBox(height: sep,),
      PswInputWidget(
        validar: true,
        controller: tecPsw,
        nombre: 'Contraseña',
        placeholder: 'Ingresa tu contraseña',
        backColor: colorCampo,
        err: le.find("psw"),
        vcPsw: vcPsw,
      ),
      SizedBox(height: sep,),
      PswInputWidget(
        validar: false,
        controller: tecConfPsw,
        nombre: 'Confirmar Contraseña',
        placeholder: 'Ingresa tu contraseña',
        backColor: colorCampo,
        err: le.find("confpsw"),
      ),
      SizedBox(height: sep*2,),
      ExecButton(
        color: colorButton,
        text: 'Siguiente',
        onPressed: () async {
          cargando.show();
          le = await Estado().cuc.pasoUno(
            context: context,
            email: tecEmail.text,
            psw: tecPsw.text,
            confPsw: tecConfPsw.text,
          );
          cargando.hide();
          if (le.haveErrror /*|| !vcEmail.seValido || !vcPsw.seValido || tecEmail.text == emailValido*/){
            Info().showMsgDialog(context, "Creacion de usuario","algo falta de completar o esta mal puesto");
            setState(() {});
          }else{
            //Info.showMsgDialog(context, "Creacion de usuario","Siguiente paso");
            //setState(() {});
            Nav.push(
                context: context,
                next: () => Flow02CrearUsuarioWidget(),
                settingName: 'Flow02CrearUsuarioWidget',
                settingArg: null
            );
          }
          cargando.hide();
        },
      ),
      SizedBox(height: sep,),
    ];
  }
}