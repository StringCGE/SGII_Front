import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_emisor.dart';
import 'package:sgii_front/service/serv_emisor.dart';
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

class CreateEditEmisorWidget extends StatefulWidget {
  final Emisor? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditEmisorWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditEmisorWidgetState createState() => CreateEditEmisorWidgetState();
}

class CreateEditEmisorWidgetState extends State<CreateEditEmisorWidget> {

  bool estaEditando = false;

  final EmisorService _serv = EmisorService();
  PersonaService responsableS = PersonaService();

  Persona responsableSelect = Persona.empty();

  Emisor? item;

  final TextEditingController _razonSocialController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _telefonoResponsableController = TextEditingController();
  final TextEditingController _direccionMatrizController = TextEditingController();
  final TextEditingController _telefono1Controller = TextEditingController();
  final TextEditingController _telefono2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(Emisor? item) async {
    this.item = item;
    if (this.item != null){
      _razonSocialController.text = Parse.getString(this.item!.razonSocial);
      _rucController.text = Parse.getString(this.item!.ruc);
      responsableSelect = this.item!.responsable;
      _responsableController.text = this.item!.responsable.getValueStr();
      _telefonoResponsableController.text = Parse.getString(this.item!.telefonoResponsable);
      _direccionMatrizController.text = Parse.getString(this.item!.direccionMatriz);
      _telefono1Controller.text = Parse.getString(this.item!.telefono1);
      _telefono2Controller.text = Parse.getString(this.item!.telefono2);
      _emailController.text = Parse.getString(this.item!.email);

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
          widget.item!.razonSocial = Parse.getString(_razonSocialController.text);
          widget.item!.ruc = Parse.getString(_rucController.text);
          widget.item!.responsable = responsableSelect;
          widget.item!.telefonoResponsable = Parse.getString(_telefonoResponsableController.text);
          widget.item!.direccionMatriz = Parse.getString(_direccionMatrizController.text);
          widget.item!.telefono1 = Parse.getString(_telefono1Controller.text);
          widget.item!.telefono2 = Parse.getString(_telefono2Controller.text);
          widget.item!.email = Parse.getString(_emailController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de Emisor', 'Emisor actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del emisor');
          }
        } else {
          Emisor item_ = Emisor(
            razonSocial : Parse.getString(_razonSocialController.text),
            ruc : Parse.getString(_rucController.text),
            responsable : responsableSelect,
            telefonoResponsable : Parse.getString(_telefonoResponsableController.text),
            direccionMatriz : Parse.getString(_direccionMatrizController.text),
            telefono1 : Parse.getString(_telefono1Controller.text),
            telefono2 : Parse.getString(_telefono2Controller.text),
            email : Parse.getString(_emailController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar Emisor', 'Emisor agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el emisor');
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
    //Text(estaEditando ? 'Editar Emisor' : 'Crear Emisor'),
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
                 controller: _razonSocialController,
                 labelText: 'RazonSocial',
                 hintText: 'Escriba RazonSocial',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _rucController,
                 labelText: 'Ruc',
                 hintText: 'Escriba Ruc',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               SinglePickListPersonaWidget(
                 getItem: () {
                   return responsableSelect;
                 },
                 setItem: (Persona? item) {
                   responsableSelect = item ?? Persona.empty();
                 },
                 labelText: 'Responsable',
                 hintText: 'Seleccione responsable (Persona)',
                 addtext: 'Agregar responsable (Persona)',
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _telefonoResponsableController,
                 labelText: 'TelefonoResponsable',
                 hintText: 'Escriba TelefonoResponsable',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _direccionMatrizController,
                 labelText: 'DireccionMatriz',
                 hintText: 'Escriba DireccionMatriz',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _telefono1Controller,
                 labelText: 'Telefono1',
                 hintText: 'Escriba Telefono1',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _telefono2Controller,
                 labelText: 'Telefono2',
                 hintText: 'Escriba Telefono2',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _emailController,
                 labelText: 'Email',
                 hintText: 'Escriba Email',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar Emisor' : 'Guardar Emisor'),
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