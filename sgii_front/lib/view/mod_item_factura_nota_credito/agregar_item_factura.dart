import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_item_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_item_factura_nota_credito.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/bool_widget.dart';
import 'package:sgii_front/util/my_widget/dinero_widget.dart';
import 'package:sgii_front/util/my_widget/num_widget.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_factura_nota_credito.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/combo_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/create_edit_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/single_pick_list_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/multi_pick_list_factura_nota_credito_widget.dart';
import 'package:sgii_front/model/cls_producto.dart';
import 'package:sgii_front/service/serv_producto.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/create_edit_item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/item_item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_producto/combo_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/create_edit_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/filter_list_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/item_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/single_pick_list_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/multi_pick_list_producto_widget.dart';

class AgregarItemFacturaWidget extends StatefulWidget {
  final ItemFacturaNotaCredito? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const AgregarItemFacturaWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  AgregarItemFacturaWidgetState createState() => AgregarItemFacturaWidgetState();
}

class AgregarItemFacturaWidgetState extends State<AgregarItemFacturaWidget> {

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
    _cantidadController.addListener((){
      calcular();
    });
  }

  void calcular(){
    if (productoSelect.estado < 0){
      _totalController.text = '0.00';
    }else{
      cantidad = Parse.getDouble(_cantidadController.text);
      total = cantidad * productoSelect.precio;
      _totalController.text = total.toStringAsFixed(2);
    }
  }
  double cantidad = 0;
  double total = 0;

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
    Result? r;
    if (_formKey.currentState?.validate() ?? false) {
      try{
        if (estaEditando) {
          widget.item!.facturaNotaCredito = facturaNotaCreditoSelect;
          widget.item!.cantidad = Parse.getInt(_cantidadController.text);
          widget.item!.producto = productoSelect;
          widget.item!.precioUnitario = Parse.getDouble(_precioUnitarioController.text);
          widget.item!.total = Parse.getDouble(_totalController.text);
          widget.item!.tipoTransac = Parse.getInt(_tipoTransacController.text);
          r = Result(
            value: widget.item!,
            success: true,
            errror: '',
          );
        } else {
          ItemFacturaNotaCredito item_ = ItemFacturaNotaCredito(
            facturaNotaCredito : facturaNotaCreditoSelect,
            cantidad : Parse.getInt(_cantidadController.text),
            producto : productoSelect,
            precioUnitario : Parse.getDouble(productoSelect.precio),
            total : total,
            tipoTransac : Parse.getInt(_tipoTransacController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = Result(
            value: item_,
            success: true,
            errror: '',
          );
        }
      }catch(e){
        r = Result(
          success: false,
          errror: '',
          e: e,
        );
      }
    } else {
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

  //final TextEditingController _nombreController = TextEditingController();
  //final TextEditingController _itemController = TextEditingController();
  //final GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>> _searchListItemFacturaNotaCreditoWidgetKey = GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>>();
  //ItemFacturaNotaCredito itemSelect = ItemFacturaNotaCredito.empty();
  //ItemFacturaNotaCreditoService servItemFacturaNotaCredito = ItemFacturaNotaCreditoService();
  //ItemFacturaNotaCredito? value;
  //List<ItemList<DbObj>> lItemPickList = [];


  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<Producto>> _searchListProductoWidgetKey = GlobalKey<SearchListWidgetState<Producto>>();
  Producto itemSelect = Producto.empty();
  ProductoService servProducto = ProductoService();
  Producto? value;
  List<ItemList<DbObj>> lItemPickList = [];

  @override
  Widget build(BuildContext context) {
    //Text(estaEditando ? 'Editar ItemFacturaNotaCredito' : 'Crear ItemFacturaNotaCredito'),
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    SizedBox(
                      width: 250,
                      child: GroupWidget(
                        labelText: '',
                        children: [
                          NumWidget(
                            controller: _cantidadController,
                            labelText: 'Cantidad',
                            hintText: 'Escriba Cantidad',
                            validator: validateNotEmpty,
                            allowDecimals: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16, height: 16),
                    SizedBox(
                      width: 250,  // También ocupa la mitad del ancho de la pantalla
                      child: GroupWidget(
                        labelText: '',
                        children: [
                          DineroWidget(
                            readOnly: true,
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
                                  estaEditando ? 'Actualizar ItemFacturaNotaCredito' : 'Vender',
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
                          if (widget.mostrarCancelar)
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  widget.result(Result(
                                    success: true,
                                    message: 'Se cancelo',
                                    errror: '',
                                  ));
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
                                // Acción para "Descargar"
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

                  ],
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  child: SearchListWidget<Producto>(
                    key: _searchListProductoWidgetKey,
                    itemCard: (BuildContext context, ItemList<DbObj> item_) {
                      ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                            (item){
                          if (item.value.idApi >= 0){
                            return item.value.idApi == item_.value.idApi;
                          }else{
                            return item.value.id == item_.value.id;
                          }
                        },
                        orElse: () => ItemList<DbObj>( value: Producto.empty()),
                      );
                      if (encontrado.value.estado != Producto.empty().estado){
                        item_.selected = encontrado.selected;
                      }else{
                        item_.selected = false;
                      }
                      return ItemProductoWidget(
                        item: item_,
                        listWidgetKey: null,
                        searchListWidgetKey: _searchListProductoWidgetKey,
                        selectedItem: (BuildContext itemProductoWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                          item.selected = !item.selected;
                          ItemList<DbObj>? itemAnt;
                          if (lItemPickList.isNotEmpty){
                            itemAnt = lItemPickList.elementAt(0);
                            itemAnt.selected = false;
                          }
                          if (item.selected){
                            lItemPickList.clear();
                            lItemPickList.add(item);
                            productoSelect = item.value as Producto;
                            //widget.setItem(item.value as Producto);
                          }else{
                            lItemPickList.remove(item);
                            productoSelect = Producto.empty();
                          }
                          fSetState();
                          calcular();
                          _searchListProductoWidgetKey.currentState?.resetGuardaPosLista();
                        },
                      );
                    },
                    fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
                      ResultOf<List<Producto>> result = await servProducto.fetchDataFind(
                          offset,
                          take,
                          _nombreController.text.isEmpty ? null : _nombreController.text);
                      return result;
                    },
                    finds: (BuildContext context) {
                      return <Widget>[
                        Container(
                          width: 300,
                          height: 60,
                          child: TextField(
                            controller: _nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ];
                    },
                    create: (BuildContext context) async {
                      Result? res;
                      await showDialog(
                        context: context,
                        builder: (BuildContext alertDialogContext){
                          return AlertDialog(
                            title: Text('Agregar producto'/*widget.addtext*/),
                            content: CreateEditProductoWidget(
                                mostrarCancelar: true,
                                item:null,
                                result: (Result r){
                                  res = r;
                                  if (r.success){
                                    //Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                                    Nav.navPop(context: alertDialogContext);
                                  }
                                  //Navigator.of(context).pop();
                                  //Navigator.pop(alertDialogContext);
                                }
                            ),
                          );
                        },
                      );
                      if (res == null){
                        return Result(success: false,);
                      }
                      return res!;
                    },
                  ),
                  /*FilterListProductoWidget(
                        selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {

                        },
                      ),*/
                ),
                SizedBox(height: 16),
                SizedBox(height: 16),

              ],
            ),
          )
      ),
    );
  }
}