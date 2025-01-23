import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_item_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_item_factura_nota_credito.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/dinero_widget.dart';
import 'package:sgii_front/util/my_widget/num_widget.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_factura_nota_credito.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/combo_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/single_pick_list_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/multi_pick_list_factura_nota_credito_widget.dart';
import 'package:sgii_front/model/cls_producto.dart';
import 'package:sgii_front/service/serv_producto.dart';
import 'package:sgii_front/view/mod_producto/combo_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/single_pick_list_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/multi_pick_list_producto_widget.dart';

class CreateEditItemFacturaNotaCreditoWidget extends StatefulWidget {
  final ItemFacturaNotaCredito? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditItemFacturaNotaCreditoWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditItemFacturaNotaCreditoWidgetState createState() => CreateEditItemFacturaNotaCreditoWidgetState();
}

class CreateEditItemFacturaNotaCreditoWidgetState extends State<CreateEditItemFacturaNotaCreditoWidget> {

  bool estaEditando = false;

  final ItemFacturaNotaCreditoService _serv = ItemFacturaNotaCreditoService();
  FacturaNotaCreditoService facturaNotaCreditoS = FacturaNotaCreditoService();
  ProductoService productoS = ProductoService();

  FacturaNotaCredito facturaNotaCreditoSelect = FacturaNotaCredito.empty();
  Producto productoSelect = Producto.empty();

  ItemFacturaNotaCredito? item;

  final TextEditingController _facturaNotaCreditoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _precioUnitarioController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _tipoTransacController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(ItemFacturaNotaCredito? item) async {
    this.item = item;
    if (this.item != null){
      facturaNotaCreditoSelect = this.item!.facturaNotaCredito;
      _facturaNotaCreditoController.text = this.item!.facturaNotaCredito.getValueStr();
      _cantidadController.text = Parse.intToString(this.item!.cantidad);
      productoSelect = this.item!.producto;
      _productoController.text = this.item!.producto.getValueStr();
      _precioUnitarioController.text = Parse.doubleToString(this.item!.precioUnitario);
      _totalController.text = Parse.doubleToString(this.item!.total);
      _tipoTransacController.text = Parse.intToString(this.item!.tipoTransac);

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
          widget.item!.facturaNotaCredito = facturaNotaCreditoSelect;
          widget.item!.cantidad = Parse.getInt(_cantidadController.text);
          widget.item!.producto = productoSelect;
          widget.item!.precioUnitario = Parse.getDouble(_precioUnitarioController.text);
          widget.item!.total = Parse.getDouble(_totalController.text);
          widget.item!.tipoTransac = Parse.getInt(_tipoTransacController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de ItemFacturaNotaCredito', 'ItemFacturaNotaCredito actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del itemFacturaNotaCredito');
          }
        } else {
          ItemFacturaNotaCredito item_ = ItemFacturaNotaCredito(
            facturaNotaCredito : facturaNotaCreditoSelect,
            cantidad : Parse.getInt(_cantidadController.text),
            producto : productoSelect,
            precioUnitario : Parse.getDouble(_precioUnitarioController.text),
            total : Parse.getDouble(_totalController.text),
            tipoTransac : Parse.getInt(_tipoTransacController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar ItemFacturaNotaCredito', 'ItemFacturaNotaCredito agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el itemFacturaNotaCredito');
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
    //Text(estaEditando ? 'Editar ItemFacturaNotaCredito' : 'Crear ItemFacturaNotaCredito'),
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SinglePickListFacturaNotaCreditoWidget(
                 getItem: () {
                   return facturaNotaCreditoSelect;
                 },
                 setItem: (FacturaNotaCredito? item) {
                   facturaNotaCreditoSelect = item ?? FacturaNotaCredito.empty();
                 },
                 labelText: 'FacturaNotaCredito',
                 hintText: 'Seleccione facturaNotaCredito (FacturaNotaCredito)',
                 addtext: 'Agregar facturaNotaCredito (FacturaNotaCredito)',
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
               SinglePickListProductoWidget(
                 getItem: () {
                   return productoSelect;
                 },
                 setItem: (Producto? item) {
                   productoSelect = item ?? Producto.empty();
                 },
                 labelText: 'Producto',
                 hintText: 'Seleccione producto (Producto)',
                 addtext: 'Agregar producto (Producto)',
               ),
               SizedBox(height: 16),
               DineroWidget(
                 controller: _precioUnitarioController,
                 labelText: 'PrecioUnitario',
                 hintText: 'Escriba PrecioUnitario',
                 validator: validateNotEmpty,
                 currencyText: 'USD',
               ),
               SizedBox(height: 16),
               DineroWidget(
                 controller: _totalController,
                 labelText: 'Total',
                 hintText: 'Escriba Total',
                 validator: validateNotEmpty,
                 currencyText: 'USD',
               ),
               SizedBox(height: 16),
               NumWidget(
                 controller: _tipoTransacController,
                 labelText: 'TipoTransac',
                 hintText: 'Escriba TipoTransac',
                 validator: validateNotEmpty,
                 allowDecimals: true,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar ItemFacturaNotaCredito' : 'Guardar ItemFacturaNotaCredito'),
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