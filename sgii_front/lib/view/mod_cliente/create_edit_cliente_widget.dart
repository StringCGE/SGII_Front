import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_cliente.dart';
import 'package:sgii_front/service/serv_cliente.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/dinero_widget.dart';
import 'package:sgii_front/util/my_widget/num_widget.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/view/mod_persona/combo_persona_widget.dart';
import 'package:sgii_front/view/mod_persona/single_pick_list_persona_widget.dart';
import 'package:sgii_front/view/mod_persona/multi_pick_list_persona_widget.dart';
import 'package:sgii_front/model/cls_tipo_identificacion.dart';
import 'package:sgii_front/service/serv_tipo_identificacion.dart';
import 'package:sgii_front/view/mod_tipo_identificacion/combo_tipo_identificacion_widget.dart';
import 'package:sgii_front/view/mod_tipo_identificacion/single_pick_list_tipo_identificacion_widget.dart';
import 'package:sgii_front/view/mod_tipo_identificacion/multi_pick_list_tipo_identificacion_widget.dart';

class CreateEditClienteWidget extends StatefulWidget {
  final Cliente? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditClienteWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditClienteWidgetState createState() => CreateEditClienteWidgetState();
}

class CreateEditClienteWidgetState extends State<CreateEditClienteWidget> {

  bool estaEditando = false;

  final ClienteService _serv = ClienteService();
  PersonaService personaS = PersonaService();
  TipoIdentificacionService tipoIdentificacionS = TipoIdentificacionService();

  Persona personaSelect = Persona.empty();
  TipoIdentificacion tipoIdentificacionSelect = TipoIdentificacion.empty();

  Cliente? item;

  final TextEditingController _personaController = TextEditingController();
  final TextEditingController _identificacionController = TextEditingController();
  final TextEditingController _tipoIdentificacionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(Cliente? item) async {
    this.item = item;
    if (this.item != null){
      personaSelect = this.item!.persona;
      _personaController.text = this.item!.persona.getValueStr();
      _identificacionController.text = Parse.getString(this.item!.identificacion);
      tipoIdentificacionSelect = this.item!.tipoIdentificacion;
      _tipoIdentificacionController.text = this.item!.tipoIdentificacion.getValueStr();
      _telefonoController.text = Parse.getString(this.item!.telefono);

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
          widget.item!.persona = personaSelect;
          widget.item!.identificacion = Parse.getString(_identificacionController.text);
          widget.item!.tipoIdentificacion = tipoIdentificacionSelect;
          widget.item!.telefono = Parse.getString(_telefonoController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de Cliente', 'Cliente actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del cliente');
          }
        } else {
          Cliente item_ = Cliente(
            persona : personaSelect,
            identificacion : Parse.getString(_identificacionController.text),
            tipoIdentificacion : tipoIdentificacionSelect,
            telefono : Parse.getString(_telefonoController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar Cliente', 'Cliente agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el cliente');
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
    //Text(estaEditando ? 'Editar Cliente' : 'Crear Cliente'),
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SinglePickListPersonaWidget(
                 getItem: () {
                   return personaSelect;
                 },
                 setItem: (Persona? item) {
                   personaSelect = item ?? Persona.empty();
                 },
                 labelText: 'Persona',
                 hintText: 'Seleccione persona (Persona)',
                 addtext: 'Agregar persona (Persona)',
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _identificacionController,
                 labelText: 'Identificacion',
                 hintText: 'Escriba Identificacion',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               SinglePickListTipoIdentificacionWidget(
                 getItem: () {
                   return tipoIdentificacionSelect;
                 },
                 setItem: (TipoIdentificacion? item) {
                   tipoIdentificacionSelect = item ?? TipoIdentificacion.empty();
                 },
                 labelText: 'TipoIdentificacion',
                 hintText: 'Seleccione tipoIdentificacion (TipoIdentificacion)',
                 addtext: 'Agregar tipoIdentificacion (TipoIdentificacion)',
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _telefonoController,
                 labelText: 'Telefono',
                 hintText: 'Escriba Telefono',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar Cliente' : 'Guardar Cliente'),
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