import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_tipo_identificacion.dart';
import 'package:sgii_front/service/serv_tipo_identificacion.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/dinero_widget.dart';
import 'package:sgii_front/util/my_widget/num_widget.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/service/serv_nacionalidad.dart';
import 'package:sgii_front/view/mod_nacionalidad/combo_nacionalidad_widget.dart';
import 'package:sgii_front/view/mod_nacionalidad/single_pick_list_nacionalidad_widget.dart';

class CreateEditTipoIdentificacionWidget extends StatefulWidget {
  final TipoIdentificacion? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditTipoIdentificacionWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditTipoIdentificacionWidgetState createState() => CreateEditTipoIdentificacionWidgetState();
}

class CreateEditTipoIdentificacionWidgetState extends State<CreateEditTipoIdentificacionWidget> {

  bool estaEditando = false;

  final TipoIdentificacionService _serv = TipoIdentificacionService();
  NacionalidadService paisS = NacionalidadService();

  Nacionalidad paisSelect = Nacionalidad.empty();

  TipoIdentificacion? item;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _detalleController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(TipoIdentificacion? item) async {
    this.item = item;
    if (this.item != null){
      _nombreController.text = Parse.getString(this.item!.nombre);
      _detalleController.text = Parse.getString(this.item!.detalle);
      paisSelect = this.item!.pais;
      _paisController.text = this.item!.pais.getValueStr();

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
          widget.item!.nombre = Parse.getString(_nombreController.text);
          widget.item!.detalle = Parse.getString(_detalleController.text);
          widget.item!.pais = paisSelect;

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de TipoIdentificacion', 'TipoIdentificacion actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del tipoIdentificacion');
          }
        } else {
          TipoIdentificacion item_ = TipoIdentificacion(
            nombre : Parse.getString(_nombreController.text),
            detalle : Parse.getString(_detalleController.text),
            pais : paisSelect,
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar TipoIdentificacion', 'TipoIdentificacion agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el tipoIdentificacion');
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
    //Text(estaEditando ? 'Editar TipoIdentificacion' : 'Crear TipoIdentificacion'),
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
                 controller: _nombreController,
                 labelText: 'Nombre',
                 hintText: 'Escriba Nombre',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _detalleController,
                 labelText: 'Detalle',
                 hintText: 'Escriba Detalle',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               ComboNacionalidadWidget(
                 getItem: () {
                   return paisSelect;
                 },
                 setItem: (Nacionalidad? item) {
                   paisSelect = item ?? Nacionalidad.empty();
                 },
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar TipoIdentificacion' : 'Guardar TipoIdentificacion'),
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