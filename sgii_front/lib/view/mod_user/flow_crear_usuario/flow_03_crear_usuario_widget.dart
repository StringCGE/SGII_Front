import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgii_front/model/cls_estado_civil.dart';
import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/model/cls_sexo.dart';
import 'package:sgii_front/model/estado.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/list_errror.dart';
import 'package:sgii_front/util/common/loading_overlay.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/my_widget/campos_widget.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';
import 'package:sgii_front/view/mod_estado_civil/combo_estado_civil_widget.dart';
import 'package:sgii_front/view/mod_estado_civil/single_pick_list_estado_civil_widget.dart';
import 'package:sgii_front/view/mod_nacionalidad/combo_nacionalidad_widget.dart';
import 'package:sgii_front/view/mod_nacionalidad/single_pick_list_nacionalidad_widget.dart';
import 'package:sgii_front/view/mod_sexo/combo_sexo_widget.dart';
import 'package:sgii_front/view/mod_sexo/single_pick_list_sexo_widget.dart';
import 'package:sgii_front/view/mod_user/flow_crear_usuario/flow_03_crear_usuario_widget.dart';

class Flow03CrearUsuarioWidget extends StatefulWidget{
  const Flow03CrearUsuarioWidget({
    super.key
  });
  @override
  Flow03CrearUsuarioWidgetState createState() => Flow03CrearUsuarioWidgetState();

}

class Flow03CrearUsuarioWidgetState extends State<Flow03CrearUsuarioWidget>{

  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _estadoCivilController = TextEditingController();
  final TextEditingController _nacionalidadController = TextEditingController();
  final TextEditingController _grupoSanguineoController = TextEditingController();
  final TextEditingController _tipoSanguineoController = TextEditingController();



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
    _cedulaController.text = Estado().cuc.user.persona.nombre1;
    //Estado().cuc.user.persona.sexo;
    //Estado().cuc.user.persona.estadoCivil;
    //Estado().cuc.user.persona.nacionalidad;
    _grupoSanguineoController.text = Estado().cuc.user.persona.apellido1;
    _tipoSanguineoController.text = Estado().cuc.user.persona.apellido1;

    _cedulaController.addListener((){
      Estado().cuc.user.persona.cedula = _cedulaController.text;
    });
    _grupoSanguineoController.addListener((){
      Estado().cuc.user.persona.apellido1 = _grupoSanguineoController.text;
    });
    _tipoSanguineoController.addListener((){
      Estado().cuc.user.persona.apellido2 = _tipoSanguineoController.text;
    });

    //tecNacimiento.text = Estado().cuc.nacimiento;
  }

  @override
  Widget build(BuildContext context){
    return Material(
        child:Scaffold(
          body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: partesInternas(),
          ),
                    ),
                  ),
              ]
          )
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
        controller: _cedulaController,
        nombre: 'Cedula',
        placeholder: 'Ingrese su cedula',
        backColor: colorCampo,
        err: le.find("nombre2"),
      ),
      SizedBox(height: 16),
      ComboSexoWidget(
        getItem: () {
          return Estado().cuc.user.persona.sexo;
        },
        setItem: (Sexo? item) {
          Estado().cuc.user.persona.sexo = item ?? Sexo.empty();
        },
        /*labelText: 'Sexo',
        hintText: 'Seleccione sexo (Sexo)',
        addtext: 'Agregar sexo (Sexo)',*/
      ),
      SizedBox(height: 16),
      ComboEstadoCivilWidget(
        getItem: () {
          return Estado().cuc.user.persona.estadoCivil;
        },
        setItem: (EstadoCivil? item) {
          Estado().cuc.user.persona.estadoCivil = item ?? EstadoCivil.empty();
        },
        /*labelText: 'EstadoCivil',
        hintText: 'Seleccione estadoCivil (EstadoCivil)',
        addtext: 'Agregar estadoCivil (EstadoCivil)',*/
      ),
      SizedBox(height: 16),
      ComboNacionalidadWidget(
        getItem: () {
          return Estado().cuc.user.persona.nacionalidad;
        },
        setItem: (Nacionalidad? item) {
          Estado().cuc.user.persona.nacionalidad = item ?? Nacionalidad.empty();
        },/*
        labelText: 'Nacionalidad',
        hintText: 'Seleccione nacionalidad (Nacionalidad)',
        addtext: 'Agregar nacionalidad (Nacionalidad)',*/
      ),
      SizedBox(height: sep,),
      TextLabelInputWidget(
        controller: _grupoSanguineoController,
        nombre: 'Grupo sanguineo',
        placeholder: 'Grupo sanguineo',
        backColor: colorCampo,
        //err: le.find("apellido2"),
      ),
      SizedBox(height: sep,),
      TextLabelInputWidget(
        controller: _tipoSanguineoController,
        nombre: 'Tipo sanguineo',
        placeholder: 'Ingresa tu Tipo Sanguineo',
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
            le = await Estado().cuc.pasoTres(
              context: context,
              cedula: Estado().cuc.user.persona.cedula,
              sexo: Estado().cuc.user.persona.sexo,
              estadoCivil: Estado().cuc.user.persona.estadoCivil,
              nacionalidad: Estado().cuc.user.persona.nacionalidad,
              grupoSanguineo: Estado().cuc.user.persona.grupoSanguineo,
              tipoSanguineo: Estado().cuc.user.persona.tipoSanguineo,
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


