import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_sexo.dart';
import 'package:sgii_front/service/serv_sexo.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

class CreateEditSexoWidget extends StatefulWidget {
  final Sexo? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditSexoWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditSexoWidgetState createState() => CreateEditSexoWidgetState();
}

class CreateEditSexoWidgetState extends State<CreateEditSexoWidget> {
  final SexoService _serv = SexoService();
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

  Future<void> fillEditableFields(Sexo? item) async {
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
            info.showMsgDialogAsync(context, "Actualizacion de Sexo", "Sexo actualizado");
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, "Algo falló en la actualizacion del cargo");
          }
        } else {
          Sexo item_ = Sexo(
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
            info.showMsgDialogAsync(context, "Agregar Sexo", "Sexo agregado con exito");
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
        child: SingleChildScrollView(
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
                      child: Text(estaEditando ? "Actualizar Sexo" : "Guardar Sexo"),
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






