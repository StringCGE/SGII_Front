import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_producto.dart';
import 'package:sgii_front/service/serv_producto.dart';
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

class CreateEditProductoWidget extends StatefulWidget {
  final Producto? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditProductoWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditProductoWidgetState createState() => CreateEditProductoWidgetState();
}

class CreateEditProductoWidgetState extends State<CreateEditProductoWidget> {

  bool estaEditando = false;

  final ProductoService _serv = ProductoService();
  EmisorService proveedorS = EmisorService();

  Emisor proveedorSelect = Emisor.empty();

  Producto? item;

  final TextEditingController _proveedorController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _detalleController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(Producto? item) async {
    this.item = item;
    if (this.item != null){
      proveedorSelect = this.item!.proveedor;
      _proveedorController.text = this.item!.proveedor.getValueStr();
      _nombreController.text = Parse.getString(this.item!.nombre);
      _detalleController.text = Parse.getString(this.item!.detalle);
      _precioController.text = Parse.doubleToString(this.item!.precio);
      _cantidadController.text = Parse.intToString(this.item!.cantidad);

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
          widget.item!.proveedor = proveedorSelect;
          widget.item!.nombre = Parse.getString(_nombreController.text);
          widget.item!.detalle = Parse.getString(_detalleController.text);
          widget.item!.precio = Parse.getDouble(_precioController.text);
          widget.item!.cantidad = Parse.getInt(_cantidadController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de Producto', 'Producto actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del producto');
          }
        } else {
          Producto item_ = Producto(
            proveedor : proveedorSelect,
            nombre : Parse.getString(_nombreController.text),
            detalle : Parse.getString(_detalleController.text),
            precio : Parse.getDouble(_precioController.text),
            cantidad : Parse.getInt(_cantidadController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar Producto', 'Producto agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el producto');
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
    //Text(estaEditando ? 'Editar Producto' : 'Crear Producto'),
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
                   return proveedorSelect;
                 },
                 setItem: (Emisor? item) {
                   proveedorSelect = item ?? Emisor.empty();
                 },
                 labelText: 'Proveedor',
                 hintText: 'Seleccione proveedor (Emisor)',
                 addtext: 'Agregar proveedor (Emisor)',
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
                 controller: _detalleController,
                 labelText: 'Detalle',
                 hintText: 'Escriba Detalle',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               DineroWidget(
                 controller: _precioController,
                 labelText: 'Precio',
                 hintText: 'Escriba Precio',
                 validator: validateNotEmpty,
                 currencyText: 'USD',
               ),
               SizedBox(height: 16),
               NumWidget(
                 controller: _cantidadController,
                 labelText: 'Cantidad',
                 hintText: 'Escriba Cantidad',
                 validator: validateNotEmpty,
                 allowDecimals: true,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar Producto' : 'Guardar Producto'),
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