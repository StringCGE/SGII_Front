import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgii_front/model/estado.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/list_errror.dart';
import 'package:sgii_front/util/common/loading_overlay.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/my_widget/campos_widget.dart';
import 'package:sgii_front/view/mod_user/flow_crear_usuario/flow_03_crear_usuario_widget.dart';

class Flow02CrearUsuarioWidget extends StatefulWidget{
  const Flow02CrearUsuarioWidget({
    super.key
  });
  @override
  Flow02CrearUsuarioWidgetState createState() => Flow02CrearUsuarioWidgetState();

}

class Flow02CrearUsuarioWidgetState extends State<Flow02CrearUsuarioWidget>{
  TextEditingController tecNombre1 = TextEditingController();
  TextEditingController tecNombre2 = TextEditingController();
  TextEditingController tecApellido1 = TextEditingController();
  TextEditingController tecApellido2 = TextEditingController();

  TextEditingController tecNacimiento = TextEditingController();

  DateFormat format = DateFormat('yyyy-M-d');

  late ListErrror le;
  late LoadingOverlay cargando;

  void safeSetState(){
    if (mounted) setState(() {});
  }
  @override
  void initState(){
    super.initState();
    le = ListErrror();
    cargando = LoadingOverlay(context);
    tecNombre1.text = Estado().cuc.user.persona.nombre1;
    tecNombre2.text = Estado().cuc.user.persona.nombre1;
    tecApellido1.text = Estado().cuc.user.persona.apellido1;
    tecApellido2.text = Estado().cuc.user.persona.apellido1;

    tecNombre1.addListener((){
      Estado().cuc.user.persona.nombre1 = tecNombre1.text;
    });
    tecNombre2.addListener((){
      Estado().cuc.user.persona.nombre2 = tecNombre2.text;
    });
    tecApellido1.addListener((){
      Estado().cuc.user.persona.apellido1 = tecApellido1.text;
    });
    tecApellido2.addListener((){
      Estado().cuc.user.persona.apellido2 = tecApellido2.text;
    });

    //tecNacimiento.text = Estado().cuc.nacimiento;
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
  List<Widget> partesInternas(){
    Color colorCampo = Color.fromARGB(255, 232, 182, 132);
    Color colorButton = Color.fromARGB(255, 212, 162, 112);
    double sep = 20;
    return <Widget>[

      SizedBox(height: sep,),
      TextLabelInputWidget(
        controller: tecNombre1,
        nombre: 'Primer Nombre',
        placeholder: 'Ingrese su primer nombre',
        backColor: colorCampo,
        err: le.find("nombre1"),
      ),
      SizedBox(height: sep,),
      TextLabelInputWidget(
        controller: tecNombre2,
        nombre: 'Segundo Nombre',
        placeholder: 'Ingrese su segundo nombre',
        backColor: colorCampo,
        err: le.find("nombre2"),
      ),
      SizedBox(height: sep,),
      TextLabelInputWidget(
        controller: tecApellido1,
        nombre: 'Priemr apellido',
        placeholder: 'Ingrese su primer apellido',
        backColor: colorCampo,
        err: le.find("apellido1"),
      ),
      SizedBox(height: sep,),
      TextLabelInputWidget(
        controller: tecApellido2,
        nombre: 'Segundo apellido',
        placeholder: 'Ingresa tu segundo apellido',
        backColor: colorCampo,
        err: le.find("apellido2"),
      ),
      SizedBox(height: sep,),
      DateInputWidget(
        controller: tecNacimiento,
        nombre: 'Fecha de nacimiento',
        placeholder: 'Ingresa tu fecha de nacimiento',
        backColor: colorCampo,
        //err: le.find(""),
      ),
      SizedBox(height: sep*2,),
      ExecButton(
        color: colorButton,
        text: 'Siguiente',
        onPressed: () async {
          cargando.show();
          try{
            DateTime dt = format.parse(tecNacimiento.text);
            le = await Estado().cuc.pasoDos(
              context: context,
              nombre1: tecNombre1.text,
              nombre2: tecNombre2.text,
              apellido1: tecApellido1.text,
              apellido2: tecApellido2.text,
              nacimiento: dt,
            );
            if (le.haveErrror){
              Info().toastFlotante("algo falta de completar o esta mal puesto");
              cargando.hide();
              setState(() {});
            }else{
              cargando.hide();
              Nav.navDropUpToWidget(
                context: context,
                next: () => Flow03CrearUsuarioWidget(),
                settingName: 'Flow03CrearUsuarioWidget',
                settingArg: null,
                stopWidgetName: 'LoginWidget',
              );
            }
          }catch(ex){
            cargando.hide();
            int i = 0;
            i = 1;
          }
        },
      ),
    ];
  }
}

