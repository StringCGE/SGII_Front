import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_factura_nota_credito.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/dinero_widget.dart';
import 'package:sgii_front/util/my_widget/num_widget.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_emisor_item.dart';
import 'package:sgii_front/service/serv_emisor_item.dart';
import 'package:sgii_front/view/mod_emisor_item/combo_emisor_item_widget.dart';
import 'package:sgii_front/view/mod_emisor_item/single_pick_list_emisor_item_widget.dart';
import 'package:sgii_front/view/mod_emisor_item/multi_pick_list_emisor_item_widget.dart';
import 'package:sgii_front/model/cls_registro_doc.dart';
import 'package:sgii_front/service/serv_registro_doc.dart';
import 'package:sgii_front/view/mod_registro_doc/combo_registro_doc_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/single_pick_list_registro_doc_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/multi_pick_list_registro_doc_widget.dart';
import 'package:sgii_front/model/cls_cliente.dart';
import 'package:sgii_front/service/serv_cliente.dart';
import 'package:sgii_front/view/mod_cliente/combo_cliente_widget.dart';
import 'package:sgii_front/view/mod_cliente/single_pick_list_cliente_widget.dart';
import 'package:sgii_front/view/mod_cliente/multi_pick_list_cliente_widget.dart';

class CreateEditFacturaNotaCreditoWidget extends StatefulWidget {
  final FacturaNotaCredito? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditFacturaNotaCreditoWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditFacturaNotaCreditoWidgetState createState() => CreateEditFacturaNotaCreditoWidgetState();
}

class CreateEditFacturaNotaCreditoWidgetState extends State<CreateEditFacturaNotaCreditoWidget> {

  bool estaEditando = false;

  final FacturaNotaCreditoService _serv = FacturaNotaCreditoService();
  EmisorItemService emisorS = EmisorItemService();
  RegistroDocService registroFacturaS = RegistroDocService();
  ClienteService clienteS = ClienteService();

  EmisorItem emisorSelect = EmisorItem.empty();
  RegistroDoc registroFacturaSelect = RegistroDoc.empty();
  Cliente clienteSelect = Cliente.empty();

  FacturaNotaCredito? item;

  final TextEditingController _emisorController = TextEditingController();
  final TextEditingController _registroFacturaController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _claveAccesoController = TextEditingController();
  final TextEditingController _esFacturaController = TextEditingController();
  final TextEditingController _autorizacionController = TextEditingController();
  final TextEditingController _subtotalPrevioController = TextEditingController();
  final TextEditingController _subtotal0Controller = TextEditingController();
  final TextEditingController _descuentoController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();
  final TextEditingController _ivaController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _pagoEfectivoController = TextEditingController();
  final TextEditingController _pagoTarjetaDebCredController = TextEditingController();
  final TextEditingController _pagoOtraFormaController = TextEditingController();
  final TextEditingController _pagoOtraFormaDetalleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(FacturaNotaCredito? item) async {
    this.item = item;
    if (this.item != null){
      emisorSelect = this.item!.emisor;
      _emisorController.text = this.item!.emisor.getValueStr();
      registroFacturaSelect = this.item!.registroFactura;
      _registroFacturaController.text = this.item!.registroFactura.getValueStr();
      clienteSelect = this.item!.cliente;
      _clienteController.text = this.item!.cliente.getValueStr();
      _claveAccesoController.text = Parse.getString(this.item!.claveAcceso);
      _esFacturaController.text = Parse.boolToString(this.item!.esFactura);
      _autorizacionController.text = Parse.getString(this.item!.autorizacion);
      _subtotalPrevioController.text = Parse.doubleToString(this.item!.subtotalPrevio);
      _subtotal0Controller.text = Parse.doubleToString(this.item!.subtotal0);
      _descuentoController.text = Parse.doubleToString(this.item!.descuento);
      _subtotalController.text = Parse.doubleToString(this.item!.subtotal);
      _ivaController.text = Parse.doubleToString(this.item!.iva);
      _totalController.text = Parse.doubleToString(this.item!.total);
      _pagoEfectivoController.text = Parse.doubleToString(this.item!.pagoEfectivo);
      _pagoTarjetaDebCredController.text = Parse.doubleToString(this.item!.pagoTarjetaDebCred);
      _pagoOtraFormaController.text = Parse.doubleToString(this.item!.pagoOtraForma);
      _pagoOtraFormaDetalleController.text = Parse.getString(this.item!.pagoOtraFormaDetalle);

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
          widget.item!.registroFactura = registroFacturaSelect;
          widget.item!.cliente = clienteSelect;
          widget.item!.claveAcceso = Parse.getString(_claveAccesoController.text);
          widget.item!.esFactura = Parse.getBool(_esFacturaController.text);
          widget.item!.autorizacion = Parse.getString(_autorizacionController.text);
          widget.item!.subtotalPrevio = Parse.getDouble(_subtotalPrevioController.text);
          widget.item!.subtotal0 = Parse.getDouble(_subtotal0Controller.text);
          widget.item!.descuento = Parse.getDouble(_descuentoController.text);
          widget.item!.subtotal = Parse.getDouble(_subtotalController.text);
          widget.item!.iva = Parse.getDouble(_ivaController.text);
          widget.item!.total = Parse.getDouble(_totalController.text);
          widget.item!.pagoEfectivo = Parse.getDouble(_pagoEfectivoController.text);
          widget.item!.pagoTarjetaDebCred = Parse.getDouble(_pagoTarjetaDebCredController.text);
          widget.item!.pagoOtraForma = Parse.getDouble(_pagoOtraFormaController.text);
          widget.item!.pagoOtraFormaDetalle = Parse.getString(_pagoOtraFormaDetalleController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de FacturaNotaCredito', 'FacturaNotaCredito actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del facturaNotaCredito');
          }
        } else {
          FacturaNotaCredito item_ = FacturaNotaCredito(
            emisor : emisorSelect,
            registroFactura : registroFacturaSelect,
            cliente : clienteSelect,
            claveAcceso : Parse.getString(_claveAccesoController.text),
            esFactura : Parse.getBool(_esFacturaController.text),
            autorizacion : Parse.getString(_autorizacionController.text),
            subtotalPrevio : Parse.getDouble(_subtotalPrevioController.text),
            subtotal0 : Parse.getDouble(_subtotal0Controller.text),
            descuento : Parse.getDouble(_descuentoController.text),
            subtotal : Parse.getDouble(_subtotalController.text),
            iva : Parse.getDouble(_ivaController.text),
            total : Parse.getDouble(_totalController.text),
            pagoEfectivo : Parse.getDouble(_pagoEfectivoController.text),
            pagoTarjetaDebCred : Parse.getDouble(_pagoTarjetaDebCredController.text),
            pagoOtraForma : Parse.getDouble(_pagoOtraFormaController.text),
            pagoOtraFormaDetalle : Parse.getString(_pagoOtraFormaDetalleController.text),
            lItem: [],//lItem.map((ItemList<DbObj> val) => val.value).toList(),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar FacturaNotaCredito', 'FacturaNotaCredito agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el facturaNotaCredito');
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
    //Text(estaEditando ? 'Editar FacturaNotaCredito' : 'Crear FacturaNotaCredito'),
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SinglePickListEmisorItemWidget(
                 getItem: () {
                   return emisorSelect;
                 },
                 setItem: (EmisorItem? item) {
                   emisorSelect = item ?? EmisorItem.empty();
                 },
                 labelText: 'Emisor',
                 hintText: 'Seleccione emisor (EmisorItem)',
                 addtext: 'Agregar emisor (EmisorItem)',
               ),
               SizedBox(height: 16),
               SinglePickListRegistroDocWidget(
                 getItem: () {
                   return registroFacturaSelect;
                 },
                 setItem: (RegistroDoc? item) {
                   registroFacturaSelect = item ?? RegistroDoc.empty();
                 },
                 labelText: 'RegistroFactura',
                 hintText: 'Seleccione registroFactura (RegistroDoc)',
                 addtext: 'Agregar registroFactura (RegistroDoc)',
               ),
               SizedBox(height: 16),
               SinglePickListClienteWidget(
                 getItem: () {
                   return clienteSelect;
                 },
                 setItem: (Cliente? item) {
                   clienteSelect = item ?? Cliente.empty();
                 },
                 labelText: 'Cliente',
                 hintText: 'Seleccione cliente (Cliente)',
                 addtext: 'Agregar cliente (Cliente)',
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _claveAccesoController,
                 labelText: 'ClaveAcceso',
                 hintText: 'Escriba ClaveAcceso',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               BoolWidget(
                 labelText: 'EsFactura',
                 setValue: (bool value) {
                   _esFacturaController.text = value.toString();
                 },
                 getValue: () {
                   return _esFacturaController.text.toLowerCase() == 'true';
                 },
               ),
               TextWidget(
                 controller: _autorizacionController,
                 labelText: 'Autorizacion',
                 hintText: 'Escriba Autorizacion',
                 validator: validateNotEmpty,
               ),
               Wrap(
                 children: [
                   SizedBox(
                     width: (MediaQuery.of(context).size.width / 2) - 20,  // Establece un tamaño fijo del 50% de la pantalla
                     child: GroupWidget(
                       labelText: '',
                       children: [
                         LineDineroWidget(
                           controller: _subtotalPrevioController,
                           labelText: 'SubtotalPrevio',
                           hintText: 'Escriba SubtotalPrevio',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineDineroWidget(
                           controller: _subtotal0Controller,
                           labelText: 'Subtotal0',
                           hintText: 'Escriba Subtotal0',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineDineroWidget(
                           controller: _descuentoController,
                           labelText: 'Descuento',
                           hintText: 'Escriba Descuento',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineDineroWidget(
                           controller: _subtotalController,
                           labelText: 'Subtotal',
                           hintText: 'Escriba Subtotal',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineDineroWidget(
                           controller: _ivaController,
                           labelText: 'Iva',
                           hintText: 'Escriba Iva',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineDineroWidget(
                           controller: _totalController,
                           labelText: 'Total',
                           hintText: 'Escriba Total',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                       ],
                     ),
                   ),
                   SizedBox(width: 16, height: 16),
                   SizedBox(
                     width: (MediaQuery.of(context).size.width / 2) - 20,  // También ocupa la mitad del ancho de la pantalla
                     child: GroupWidget(
                       labelText: 'Forma de pago',
                       children: [
                         LineDineroWidget(
                           controller: _pagoEfectivoController,
                           labelText: 'Efectivo',
                           hintText: 'Escriba PagoEfectivo',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineDineroWidget(
                           controller: _pagoTarjetaDebCredController,
                           labelText: 'Tarjeta',
                           hintText: 'Escriba PagoTarjetaDebCred',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineDineroWidget(
                           controller: _pagoOtraFormaController,
                           labelText: 'Otra Forma',
                           hintText: 'Valor de otra forma de pago',
                           validator: validateNotEmpty,
                           currencyText: 'USD',
                         ),
                         LineTextWidget(
                           controller: _pagoOtraFormaDetalleController,
                           labelText: 'Otra Forma Detalle',
                           hintText: 'Escriba el detalle',
                           validator: validateNotEmpty,
                         ),
                       ],
                     ),
                   ),
                 ],
               ),


               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar FacturaNotaCredito' : 'Guardar FacturaNotaCredito'),
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