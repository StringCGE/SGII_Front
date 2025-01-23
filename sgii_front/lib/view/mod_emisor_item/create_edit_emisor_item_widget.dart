import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_emisor_item.dart';
import 'package:sgii_front/service/serv_emisor_item.dart';
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
import 'package:sgii_front/model/cls_emisor_establecimiento.dart';
import 'package:sgii_front/service/serv_emisor_establecimiento.dart';
import 'package:sgii_front/view/mod_emisor_establecimiento/combo_emisor_establecimiento_widget.dart';
import 'package:sgii_front/view/mod_emisor_establecimiento/single_pick_list_emisor_establecimiento_widget.dart';
import 'package:sgii_front/view/mod_emisor_establecimiento/multi_pick_list_emisor_establecimiento_widget.dart';

class CreateEditEmisorItemWidget extends StatefulWidget {
  final EmisorItem? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditEmisorItemWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditEmisorItemWidgetState createState() => CreateEditEmisorItemWidgetState();
}

class CreateEditEmisorItemWidgetState extends State<CreateEditEmisorItemWidget> {

  bool estaEditando = false;

  final EmisorItemService _serv = EmisorItemService();
  EmisorService emisorS = EmisorService();
  EmisorEstablecimientoService emisorEstablecimientoS = EmisorEstablecimientoService();

  Emisor emisorSelect = Emisor.empty();
  EmisorEstablecimiento emisorEstablecimientoSelect = EmisorEstablecimiento.empty();

  EmisorItem? item;

  final TextEditingController _emisorController = TextEditingController();
  final TextEditingController _emisorEstablecimientoController = TextEditingController();
  final TextEditingController _puntoEmisionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(EmisorItem? item) async {
    this.item = item;
    if (this.item != null){
      emisorSelect = this.item!.emisor;
      _emisorController.text = this.item!.emisor.getValueStr();
      emisorEstablecimientoSelect = this.item!.emisorEstablecimiento;
      _emisorEstablecimientoController.text = this.item!.emisorEstablecimiento.getValueStr();
      _puntoEmisionController.text = Parse.getString(this.item!.puntoEmision);

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
          widget.item!.emisorEstablecimiento = emisorEstablecimientoSelect;
          widget.item!.puntoEmision = Parse.getString(_puntoEmisionController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de EmisorItem', 'EmisorItem actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del emisorItem');
          }
        } else {
          EmisorItem item_ = EmisorItem(
            emisor : emisorSelect,
            emisorEstablecimiento : emisorEstablecimientoSelect,
            puntoEmision : Parse.getString(_puntoEmisionController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar EmisorItem', 'EmisorItem agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el emisorItem');
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
    //Text(estaEditando ? 'Editar EmisorItem' : 'Crear EmisorItem'),
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
               SinglePickListEmisorEstablecimientoWidget(
                 getItem: () {
                   return emisorEstablecimientoSelect;
                 },
                 setItem: (EmisorEstablecimiento? item) {
                   emisorEstablecimientoSelect = item ?? EmisorEstablecimiento.empty();
                 },
                 labelText: 'EmisorEstablecimiento',
                 hintText: 'Seleccione emisorEstablecimiento (EmisorEstablecimiento)',
                 addtext: 'Agregar emisorEstablecimiento (EmisorEstablecimiento)',
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _puntoEmisionController,
                 labelText: 'PuntoEmision',
                 hintText: 'Escriba PuntoEmision',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar EmisorItem' : 'Guardar EmisorItem'),
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