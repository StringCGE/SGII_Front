import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_registro_doc.dart';
import 'package:sgii_front/service/serv_registro_doc.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/dinero_widget.dart';
import 'package:sgii_front/util/my_widget/num_widget.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';



class CreateEditRegistroDocWidget extends StatefulWidget {
  final RegistroDoc? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditRegistroDocWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditRegistroDocWidgetState createState() => CreateEditRegistroDocWidgetState();
}

class CreateEditRegistroDocWidgetState extends State<CreateEditRegistroDocWidget> {

  bool estaEditando = false;

  final RegistroDocService _serv = RegistroDocService();




  RegistroDoc? item;

  final TextEditingController _secuencialController = TextEditingController();
  final TextEditingController _razonSocialController = TextEditingController();
  final TextEditingController _identificacionController = TextEditingController();
  final TextEditingController _fechaEmisionController = TextEditingController();
  final TextEditingController _numeroGuiaRemisionController = TextEditingController();
  final TextEditingController _codigoNumericoController = TextEditingController();
  final TextEditingController _verificadorController = TextEditingController();
  final TextEditingController _denomComproModifController = TextEditingController();
  final TextEditingController _numComproModifController = TextEditingController();
  final TextEditingController _comproModifController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(RegistroDoc? item) async {
    this.item = item;
    if (this.item != null){
      _secuencialController.text = Parse.getString(this.item!.secuencial);
      _razonSocialController.text = Parse.getString(this.item!.razonSocial);
      _identificacionController.text = Parse.getString(this.item!.identificacion);
      _fechaEmisionController.text = Parse.getString(this.item!.fechaEmision);
      _numeroGuiaRemisionController.text = Parse.getString(this.item!.numeroGuiaRemision);
      _codigoNumericoController.text = Parse.getString(this.item!.codigoNumerico);
      _verificadorController.text = Parse.getString(this.item!.verificador);
      _denomComproModifController.text = Parse.intToString(this.item!.denomComproModif);
      _numComproModifController.text = Parse.getString(this.item!.numComproModif);
      _comproModifController.text = Parse.intToString(this.item!.comproModif);

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
          widget.item!.secuencial = Parse.getString(_secuencialController.text);
          widget.item!.razonSocial = Parse.getString(_razonSocialController.text);
          widget.item!.identificacion = Parse.getString(_identificacionController.text);
          widget.item!.fechaEmision = Parse.getString(_fechaEmisionController.text);
          widget.item!.numeroGuiaRemision = Parse.getString(_numeroGuiaRemisionController.text);
          widget.item!.codigoNumerico = Parse.getString(_codigoNumericoController.text);
          widget.item!.verificador = Parse.getString(_verificadorController.text);
          widget.item!.denomComproModif = Parse.getInt(_denomComproModifController.text);
          widget.item!.numComproModif = Parse.getString(_numComproModifController.text);
          widget.item!.comproModif = Parse.getInt(_comproModifController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de RegistroDoc', 'RegistroDoc actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del registroDoc');
          }
        } else {
          RegistroDoc item_ = RegistroDoc(
            secuencial : Parse.getString(_secuencialController.text),
            razonSocial : Parse.getString(_razonSocialController.text),
            identificacion : Parse.getString(_identificacionController.text),
            fechaEmision : Parse.getString(_fechaEmisionController.text),
            numeroGuiaRemision : Parse.getString(_numeroGuiaRemisionController.text),
            codigoNumerico : Parse.getString(_codigoNumericoController.text),
            verificador : Parse.getString(_verificadorController.text),
            denomComproModif : Parse.getInt(_denomComproModifController.text),
            numComproModif : Parse.getString(_numComproModifController.text),
            comproModif : Parse.getInt(_comproModifController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar RegistroDoc', 'RegistroDoc agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el registroDoc');
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
    //Text(estaEditando ? 'Editar RegistroDoc' : 'Crear RegistroDoc'),
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
                 controller: _secuencialController,
                 labelText: 'Secuencial',
                 hintText: 'Escriba Secuencial',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _razonSocialController,
                 labelText: 'RazonSocial',
                 hintText: 'Escriba RazonSocial',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _identificacionController,
                 labelText: 'Identificacion',
                 hintText: 'Escriba Identificacion',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _fechaEmisionController,
                 labelText: 'FechaEmision',
                 hintText: 'Escriba FechaEmision',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _numeroGuiaRemisionController,
                 labelText: 'NumeroGuiaRemision',
                 hintText: 'Escriba NumeroGuiaRemision',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _codigoNumericoController,
                 labelText: 'CodigoNumerico',
                 hintText: 'Escriba CodigoNumerico',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _verificadorController,
                 labelText: 'Verificador',
                 hintText: 'Escriba Verificador',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               NumWidget(
                 controller: _denomComproModifController,
                 labelText: 'DenomComproModif',
                 hintText: 'Escriba DenomComproModif',
                 validator: validateNotEmpty,
                 allowDecimals: true,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _numComproModifController,
                 labelText: 'NumComproModif',
                 hintText: 'Escriba NumComproModif',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               NumWidget(
                 controller: _comproModifController,
                 labelText: 'ComproModif',
                 hintText: 'Escriba ComproModif',
                 validator: validateNotEmpty,
                 allowDecimals: true,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar RegistroDoc' : 'Guardar RegistroDoc'),
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