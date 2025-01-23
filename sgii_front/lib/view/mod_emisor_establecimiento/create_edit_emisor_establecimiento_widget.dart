import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_emisor_establecimiento.dart';
import 'package:sgii_front/service/serv_emisor_establecimiento.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/dinero_widget.dart';
import 'package:sgii_front/util/my_widget/num_widget.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_emisor.dart';
import 'package:sgii_front/service/serv_emisor.dart';
import 'package:sgii_front/view/mod_emisor/combo_emisor_widget.dart';
import 'package:sgii_front/view/mod_emisor/single_pick_list_emisor_widget.dart';
import 'package:sgii_front/view/mod_emisor/multi_pick_list_emisor_widget.dart';

class CreateEditEmisorEstablecimientoWidget extends StatefulWidget {
  final EmisorEstablecimiento? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditEmisorEstablecimientoWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditEmisorEstablecimientoWidgetState createState() => CreateEditEmisorEstablecimientoWidgetState();
}

class CreateEditEmisorEstablecimientoWidgetState extends State<CreateEditEmisorEstablecimientoWidget> {

  bool estaEditando = false;

  final EmisorEstablecimientoService _serv = EmisorEstablecimientoService();
  EmisorService emisorS = EmisorService();

  Emisor emisorSelect = Emisor.empty();

  EmisorEstablecimiento? item;

  final TextEditingController _emisorController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _puntosDeEmisionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(EmisorEstablecimiento? item) async {
    this.item = item;
    if (this.item != null){
      emisorSelect = this.item!.emisor;
      _emisorController.text = this.item!.emisor.getValueStr();
      _numeroController.text = Parse.intToString(this.item!.numero);
      _nombreController.text = Parse.getString(this.item!.nombre);
      _direccionController.text = Parse.getString(this.item!.direccion);
      _puntosDeEmisionController.text = Parse.getString(this.item!.puntosDeEmision);

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
          widget.item!.emisor = emisorSelect;
          widget.item!.numero = Parse.getInt(_numeroController.text);
          widget.item!.nombre = Parse.getString(_nombreController.text);
          widget.item!.direccion = Parse.getString(_direccionController.text);
          widget.item!.puntosDeEmision = Parse.getString(_puntosDeEmisionController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de EmisorEstablecimiento', 'EmisorEstablecimiento actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del emisorEstablecimiento');
          }
        } else {
          EmisorEstablecimiento item_ = EmisorEstablecimiento(
            emisor : emisorSelect,
            numero : Parse.getInt(_numeroController.text),
            nombre : Parse.getString(_nombreController.text),
            direccion : Parse.getString(_direccionController.text),
            puntosDeEmision : Parse.getString(_puntosDeEmisionController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar EmisorEstablecimiento', 'EmisorEstablecimiento agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el emisorEstablecimiento');
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
    //Text(estaEditando ? 'Editar EmisorEstablecimiento' : 'Crear EmisorEstablecimiento'),
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SinglePickListEmisorWidget(
                 getItem: () {
                   return emisorSelect;
                 },
                 setItem: (Emisor? item) {
                   emisorSelect = item ?? Emisor.empty();
                 },
                 labelText: 'Emisor',
                 hintText: 'Seleccione emisor (Emisor)',
                 addtext: 'Agregar emisor (Emisor)',
               ),
               SizedBox(height: 16),
               NumWidget(
                 controller: _numeroController,
                 labelText: 'Numero',
                 hintText: 'Escriba Numero',
                 validator: validateNotEmpty,
                 allowDecimals: true,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _nombreController,
                 labelText: 'Nombre',
                 hintText: 'Escriba Nombre',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _direccionController,
                 labelText: 'Direccion',
                 hintText: 'Escriba Direccion',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _puntosDeEmisionController,
                 labelText: 'PuntosDeEmision',
                 hintText: 'Escriba PuntosDeEmision',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar EmisorEstablecimiento' : 'Guardar EmisorEstablecimiento'),
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