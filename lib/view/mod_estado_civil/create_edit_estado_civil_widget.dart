import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_estado_civil.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_estado_civil.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

class CreateEditEstadoCivilWidget extends StatefulWidget {
  final EstadoCivil? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditEstadoCivilWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditEstadoCivilWidgetState createState() => CreateEditEstadoCivilWidgetState();
}

class CreateEditEstadoCivilWidgetState extends State<CreateEditEstadoCivilWidget> {
  final EstadoCivilService _serv = EstadoCivilService();
  bool estaEditando = false;

  final TextEditingController _nombreController = TextEditingController();


  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(EstadoCivil? item) async {
    if (item != null){
      _nombreController.text = item.nombre;
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
          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, "Actualizacion de EstadoCivil", "EstadoCivil actualizado");
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, "Algo falló en la actualizacion del cargo");
          }
        } else {
          EstadoCivil item_ = EstadoCivil(
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            nombre: Parse.getString(_nombreController.text),
            estado: Parse.getInt("1"),
            dtReg: DateTime.now(),
            idApi: 1,
            idPersReg: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, "Agregar EstadoCivil", "EstadoCivil agregado con exito");
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, "Algo falló al agregar el cargo");
          }
        }
      }catch(e){
        await info.hideLoadingMask(context);
        r = Result(
          success: false,
          errror: "",
          e: e,
        );
        info.showErrorDialogAsync(context, "Falló la conexion, intentelo de nuevo");
      }
    } else {
      await info.hideLoadingMask(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor corrija los errores')),
      );
      r = Result(
        success: false,
        errror: "Por favor corrija los errores",
      );
    }
    widget.result(r);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView( // Permite desplazamiento si el teclado está visible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                controller: _nombreController,
                labelText: "Nombre",
                hintText: "Escriba el nombre",
                validator: validateNotEmpty,
              ),
              SizedBox(height: 16),
              Wrap(
                children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: _guardar,
                      child: Text(estaEditando ? "Actualizar EstadoCivil" : "Guardar EstadoCivil"),
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
                          message: "Se cancelo",
                          errror: "",
                        ));
                      },
                      child: Text("Cancelar"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}






