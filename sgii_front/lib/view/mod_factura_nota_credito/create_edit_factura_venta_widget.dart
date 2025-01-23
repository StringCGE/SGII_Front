import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_factura_nota_credito.dart';
import 'package:sgii_front/model/cls_item_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_factura_nota_credito.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/datetime_widget.dart';
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
import 'package:sgii_front/view/mod_item_factura_nota_credito/filter_list_item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/item_item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/multi_pick_list_item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_producto/multi_pick_list_producto_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/combo_registro_doc_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/single_pick_list_registro_doc_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/multi_pick_list_registro_doc_widget.dart';
import 'package:sgii_front/model/cls_cliente.dart';
import 'package:sgii_front/service/serv_cliente.dart';
import 'package:sgii_front/view/mod_cliente/combo_cliente_widget.dart';
import 'package:sgii_front/view/mod_cliente/single_pick_list_cliente_widget.dart';
import 'package:sgii_front/view/mod_cliente/multi_pick_list_cliente_widget.dart';

class CreateEditFacturaVentaWidget extends StatefulWidget {
  final FacturaNotaCredito? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditFacturaVentaWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditFacturaVentaWidgetState createState() => CreateEditFacturaVentaWidgetState();
}

class CreateEditFacturaVentaWidgetState extends State<CreateEditFacturaVentaWidget> {

  bool estaEditando = false;

  final FacturaNotaCreditoService _serv = FacturaNotaCreditoService();
  EmisorItemService emisorS = EmisorItemService();
  RegistroDocService registroFacturaS = RegistroDocService();
  ClienteService clienteS = ClienteService();

  EmisorItem emisorSelect = EmisorItem.empty();
  RegistroDoc registroFacturaSelect = RegistroDoc.empty();
  Cliente clienteSelect = Cliente.empty();

  FacturaNotaCredito? item;


  final TextEditingController _fechaController = TextEditingController();



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
    _fechaController.text = DateTime.now().toIso8601String();
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

      lItem = widget.item!.lItem.map((val) => ItemList<DbObj>(value: val)).toList();
    }
  }

  final _formKey = GlobalKey<FormState>();

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }

  String? noValidate(String? value) {
    return null;
  }
  Future<void> _cancelar() async {
    Nav.navPop(context: context);
  }

  Future<void> _descargar() async {
    if (r.success){

    }
  }
  Result r = Result(success: false);
  Future<void> _guardar() async {
    Info info = Info();
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
          widget.item!.lItem = lItem.map((ItemList<DbObj> val)=>val.value as ItemFacturaNotaCredito).toList();
          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de FacturaVenta', 'FacturaVenta actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del FacturaVenta');
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
            lItem: lItem.map((ItemList<DbObj> val)=>val.value as ItemFacturaNotaCredito).toList(),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar FacturaVenta', 'FacturaVenta agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el FacturaVenta');
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
    //widget.result(r);
  }
  List<ItemList<DbObj>> lItem = [];
  @override
  Widget build(BuildContext context) {
    //Text(estaEditando ? 'Editar FacturaVenta' : 'Crear FacturaVenta'),
    return Container(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Container(
                          width: 550,
                          child: GroupWidget(
                            labelText: '',
                            children: [
                              LineDateTimeWidget(
                                controller: _fechaController,
                                labelText: 'Fecha',
                                hintText: 'Seleccione la fecha',
                                validator: validateNotEmpty,
                                readOnly: true,
                                labelWidth: 130,
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
                            ],
                          ),
                        ),
                        SizedBox(width: 32,height: 32),
                        Container(
                          width: 250,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: ElevatedButton.icon(
                                  onPressed: _guardar,
                                  icon: Icon(Icons.sell, color: Colors.black), // Icono de venta
                                  label: Text(
                                      estaEditando ? 'Modificar' : 'Vender',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      )
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade200, // Color verde claro
                                    minimumSize: Size(double.infinity, 50),

                                  ),
                                ),
                              ),
                              if (true)//widget.mostrarCancelar)
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _cancelar();
                                    },
                                    icon: Icon(Icons.cancel, color: Colors.black), // Icono de cancelar
                                    label: Text('Cancelar', style: TextStyle(color: Colors.black)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.shade200, // Color anaranjado claro
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _descargar();
                                  },
                                  icon: Icon(Icons.download, color: Colors.black), // Icono de descarga
                                  label: Text('Descargar', style: TextStyle(color: Colors.black)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan.shade200, // Color celeste
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 16),

/*
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
                    SizedBox(height: 16),*/

                    SizedBox(height: 16),
                    //ItemItemFacturaNotaCreditoWidget(),
                    Container(
                      height: 400,
                      child: MultiPickList01ItemFacturaNotaCreditoWidget(
                          getLItem: (){
                            return lItem;
                          },
                          setLItem: (value){
                            lItem = value ?? [];
                            aCalcular();
                          }
                      ),
                    ),
                    SizedBox(height: 16),
                    /*TextWidget(
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
                    ),*/
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
                                readOnly: true,
                              ),
                              LineDineroWidget(
                                controller: _subtotal0Controller,
                                labelText: 'Subtotal0',
                                hintText: 'Escriba Subtotal0',
                                validator: validateNotEmpty,
                                currencyText: 'USD',
                                readOnly: true,
                              ),
                              LineDineroWidget(
                                controller: _descuentoController,
                                labelText: 'Descuento',
                                hintText: 'Escriba Descuento',
                                validator: validateNotEmpty,
                                currencyText: 'USD',
                                readOnly: true,
                              ),
                              LineDineroWidget(
                                controller: _subtotalController,
                                labelText: 'Subtotal',
                                hintText: 'Escriba Subtotal',
                                validator: validateNotEmpty,
                                currencyText: 'USD',
                                readOnly: true,
                              ),
                              LineDineroWidget(
                                controller: _ivaController,
                                labelText: 'Iva',
                                hintText: 'Escriba Iva',
                                validator: validateNotEmpty,
                                currencyText: 'USD',
                                readOnly: true,
                              ),
                              LineDineroWidget(
                                controller: _totalController,
                                labelText: 'Total',
                                hintText: 'Escriba Total',
                                validator: validateNotEmpty,
                                currencyText: 'USD',
                                readOnly: true,
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
                                validator: noValidate,
                                currencyText: 'USD',
                              ),
                              LineDineroWidget(
                                controller: _pagoTarjetaDebCredController,
                                labelText: 'Tarjeta',
                                hintText: 'Escriba PagoTarjetaDebCred',
                                validator: noValidate,
                                currencyText: 'USD',
                              ),
                              LineDineroWidget(
                                controller: _pagoOtraFormaController,
                                labelText: 'Otra Forma',
                                hintText: 'Valor de otra forma de pago',
                                validator: noValidate,
                                currencyText: 'USD',
                              ),
                              LineTextWidget(
                                controller: _pagoOtraFormaDetalleController,
                                labelText: 'Otra Forma Detalle',
                                hintText: 'Escriba el detalle',
                                validator: noValidate,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              )
          ),
        )
    );
  }

  double subtotalPrevio = 0;
  double subtotal0 = 0;
  double descuento = 0;
  double subtotal = 0;
  double iva = 0;
  double total = 0;

  double descuentoPorcentaje = 0.08;
  double ivaPorcentaje = 0.15;//Si, ya se que me diran
  // que aqui no se guarda esto pero en fin, puede estar en la propia base de datos

  void aCalcular() {
    subtotalPrevio = 0;
    subtotal0 = 0;
    descuento = 0;
    subtotal = 0;
    iva = 0;
    total = 0;

    lItem.forEach((val) {
      ItemFacturaNotaCredito ifnc = val.value as ItemFacturaNotaCredito;
      //if (ifnc.grabaIva) {//Creo que ya me quede sin tiempo para esto
        subtotalPrevio += ifnc.total;
      //} else {
      //  subtotal0 += ifnc.total;
      //}
    });
    double subtotalSinDescuento = subtotalPrevio + subtotal0;
    descuento = subtotalSinDescuento * descuentoPorcentaje ;
    subtotal = subtotalSinDescuento - descuento;
    iva = (subtotalPrevio - (subtotalPrevio * descuentoPorcentaje )) * (ivaPorcentaje );

    total = subtotal + iva;

    _subtotalPrevioController.text = subtotalPrevio.toStringAsFixed(2);
    _subtotal0Controller.text = subtotal0.toStringAsFixed(2);
    _descuentoController.text = descuento.toStringAsFixed(2);
    _subtotalController.text = subtotal.toStringAsFixed(2);
    _ivaController.text = iva.toStringAsFixed(2);
    _totalController.text = total.toStringAsFixed(2);
  }

}