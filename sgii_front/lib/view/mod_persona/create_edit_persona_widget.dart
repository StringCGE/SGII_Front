import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_sexo.dart';
import 'package:sgii_front/service/serv_sexo.dart';
import 'package:sgii_front/view/mod_sexo/combo_sexo_widget.dart';
import 'package:sgii_front/model/cls_estado_civil.dart';
import 'package:sgii_front/service/serv_estado_civil.dart';
import 'package:sgii_front/view/mod_estado_civil/combo_estado_civil_widget.dart';
import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/service/serv_nacionalidad.dart';
import 'package:sgii_front/view/mod_nacionalidad/combo_nacionalidad_widget.dart';

class CreateEditPersonaWidget extends StatefulWidget {
  final Persona? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditPersonaWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditPersonaWidgetState createState() => CreateEditPersonaWidgetState();
}

class CreateEditPersonaWidgetState extends State<CreateEditPersonaWidget> {

  bool estaEditando = false;

  final PersonaService _serv = PersonaService();
  SexoService sexoS = SexoService();
  EstadoCivilService estadoCivilS = EstadoCivilService();
  NacionalidadService nacionalidadS = NacionalidadService();

  Sexo sexoSelect = Sexo.empty();
  EstadoCivil estadoCivilSelect = EstadoCivil.empty();
  Nacionalidad nacionalidadSelect = Nacionalidad.empty();

  Persona? item;

  final TextEditingController _nombre1Controller = TextEditingController();
  final TextEditingController _nombre2Controller = TextEditingController();
  final TextEditingController _apellido1Controller = TextEditingController();
  final TextEditingController _apellido2Controller = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _estadoCivilController = TextEditingController();
  final TextEditingController _nacionalidadController = TextEditingController();
  final TextEditingController _grupoSanguineoController = TextEditingController();
  final TextEditingController _tipoSanguineoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(Persona? item) async {
    this.item = item;
    if (this.item != null){
      _nombre1Controller.text = this.item!.nombre1;
      _nombre2Controller.text = this.item!.nombre2;
      _apellido1Controller.text = this.item!.apellido1;
      _apellido2Controller.text = this.item!.apellido2;
      _fechaNacimientoController.text = this.item!.fechaNacimiento.toIso8601String();
      _cedulaController.text = this.item!.cedula;
      sexoSelect = this.item!.sexo;
      _sexoController.text = this.item!.sexo.getValueStr();
      estadoCivilSelect = this.item!.estadoCivil;
      _estadoCivilController.text = this.item!.estadoCivil.getValueStr();
      nacionalidadSelect = this.item!.nacionalidad;
      _nacionalidadController.text = this.item!.nacionalidad.getValueStr();
      _grupoSanguineoController.text = this.item!.grupoSanguineo;
      _tipoSanguineoController.text = this.item!.tipoSanguineo;

    }
  }

  final _formKey = GlobalKey<FormState>();

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }




  Future<void> _guardar() async {
    Info info = Info();
    Result? r;
    if (_formKey.currentState?.validate() ?? false) {
      await info.showLoadingMask(context);

      try{
        if (estaEditando) {
          widget.item!.nombre1 = Parse.getString(_nombre1Controller.text);
          widget.item!.nombre2 = Parse.getString(_nombre2Controller.text);
          widget.item!.apellido1 = Parse.getString(_apellido1Controller.text);
          widget.item!.apellido2 = Parse.getString(_apellido2Controller.text);
          widget.item!.fechaNacimiento = Parse.getDateTime(_fechaNacimientoController.text);
          widget.item!.cedula = Parse.getString(_cedulaController.text);
          widget.item!.sexo = sexoSelect;
          widget.item!.estadoCivil = estadoCivilSelect;
          widget.item!.nacionalidad = nacionalidadSelect;
          widget.item!.grupoSanguineo = Parse.getString(_grupoSanguineoController.text);
          widget.item!.tipoSanguineo = Parse.getString(_tipoSanguineoController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de Persona', 'Persona actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del persona');
          }
        } else {
          Persona item_ = Persona(
            nombre1 : Parse.getString(_nombre1Controller.text),
            nombre2 : Parse.getString(_nombre2Controller.text),
            apellido1 : Parse.getString(_apellido1Controller.text),
            apellido2 : Parse.getString(_apellido2Controller.text),
            fechaNacimiento : Parse.getDateTime(_fechaNacimientoController.text),
            cedula : Parse.getString(_cedulaController.text),
            sexo : sexoSelect,
            estadoCivil : estadoCivilSelect,
            nacionalidad : nacionalidadSelect,
            grupoSanguineo : Parse.getString(_grupoSanguineoController.text),
            tipoSanguineo : Parse.getString(_tipoSanguineoController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar Persona', 'Persona agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el persona');
          }
        }
      }catch(e){
        await info.hideLoadingMask(context);
        r = Result(
          success: false,
          errror: '',
          e: e,
        );
        info.showErrorDialogAsync(context, 'Falló la conexion, intentelo de nuevo');
      }
    } else {
      await info.hideLoadingMask(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor corrija los errores')),
      );
      r = Result(
        success: false,
        errror: 'Por favor corrija los errores',
      );
    }
    widget.result(r);
  }

  @override
  Widget build(BuildContext context) {
    //Text(estaEditando ? 'Editar Persona' : 'Crear Persona'),
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               TextWidget(
                 controller: _nombre1Controller,
                 labelText: 'Nombre1',
                 hintText: 'Escriba Nombre1',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _nombre2Controller,
                 labelText: 'Nombre2',
                 hintText: 'Escriba Nombre2',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _apellido1Controller,
                 labelText: 'Apellido1',
                 hintText: 'Escriba Apellido1',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _apellido2Controller,
                 labelText: 'Apellido2',
                 hintText: 'Escriba Apellido2',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
                    DateWidget(
                      controller: _fechaNacimientoController,
                      labelText: 'FechaNacimiento',
                      hintText: 'Seleccione la fecha de FechaNacimiento',
                      validator: validateNotEmpty,
                    ),
                    SizedBox(height: 16),
               TextWidget(
                 controller: _cedulaController,
                 labelText: 'Cedula',
                 hintText: 'Escriba Cedula',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
                    ComboSexoWidget(
                      getItem: () {
                        return sexoSelect;
                      },
                      setItem: (Sexo? item) {
                        sexoSelect = item ?? Sexo.empty();
                      },
                    ),
                    SizedBox(height: 16),
                    ComboEstadoCivilWidget(
                      getItem: () {
                        return estadoCivilSelect;
                      },
                      setItem: (EstadoCivil? item) {
                        estadoCivilSelect = item ?? EstadoCivil.empty();
                      },
                    ),
                    SizedBox(height: 16),
                    ComboNacionalidadWidget(
                      getItem: () {
                        return nacionalidadSelect;
                      },
                      setItem: (Nacionalidad? item) {
                        nacionalidadSelect = item ?? Nacionalidad.empty();
                      },
                    ),
                    SizedBox(height: 16),
               TextWidget(
                 controller: _grupoSanguineoController,
                 labelText: 'GrupoSanguineo',
                 hintText: 'Escriba GrupoSanguineo',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _tipoSanguineoController,
                 labelText: 'TipoSanguineo',
                 hintText: 'Escriba TipoSanguineo',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar Persona' : 'Guardar Persona'),
                       style: ElevatedButton.styleFrom(
                         minimumSize: Size(double.infinity, 50),
                       ),
                     ),
                   ),
                   if(widget.mostrarCancelar)Padding(padding:
                   EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: (){
                         widget.result(Result(
                           success: true,
                           message: 'Se cancelo',
                           errror: '',
                         ));
                       },
                       child: Text('Cancelar'),
                       style: ElevatedButton.styleFrom(
                         minimumSize: Size(double.infinity, 50),
                       ),
                     ),
                   ),
                 ],
               )
             ],
            ),
          )
        ),
      )
    );
  }
}