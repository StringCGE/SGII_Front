import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_item_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_item_factura_nota_credito.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/pick_list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/agregar_item_factura.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/create_edit_item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/item_item_factura_nota_credito_widget.dart';

class MultiPickListItemFacturaNotaCreditoWidget extends StatefulWidget {
  List<ItemList<DbObj>>? Function() getLItem;
  void Function(List<ItemList<DbObj>>? item) setLItem;
  MultiPickListItemFacturaNotaCreditoWidget({
    super.key,
    required this.getLItem,
    required this.setLItem,
  });

  @override
  MultiPickListItemFacturaNotaCreditoWidgetState createState() => MultiPickListItemFacturaNotaCreditoWidgetState();
}

class MultiPickListItemFacturaNotaCreditoWidgetState extends State<MultiPickListItemFacturaNotaCreditoWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>> _searchListItemFacturaNotaCreditoWidgetKey = GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>>();
  ItemFacturaNotaCredito itemSelect = ItemFacturaNotaCredito.empty();
  ItemFacturaNotaCreditoService servItemFacturaNotaCredito = ItemFacturaNotaCreditoService();

  @override
  void initState() {
    super.initState();
    List<ItemList<DbObj>>? value = widget.getLItem();
    if (value != null){
      lItemPickList = value;
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickListWidget(
      lItemPickList: lItemPickList,
      labelText: 'ItemFacturaNotaCredito',
      hintText: 'Seleccione ItemFacturaNotaCredito',
      validator: validateNotEmpty,
      filterList: (BuildContext context, Future<void> Function() onSetState) {
        return SearchListWidget<ItemFacturaNotaCredito>(
          key: _searchListItemFacturaNotaCreditoWidgetKey,
          itemCard: (BuildContext context, ItemList<DbObj> item_) {
            ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                  (item){
                if (item.value.idApi >= 0){
                  return item.value.idApi == item_.value.idApi;
                }else{
                  return item.value.id == item_.value.id;
                }
              },
              orElse: () => ItemList<DbObj>( value: ItemFacturaNotaCredito.empty()),
            );
            if (encontrado.value.estado != ItemFacturaNotaCredito.empty().estado){
              item_.selected = encontrado.selected;
            }else{
              item_.selected = false;
            }
            return ItemItemFacturaNotaCreditoWidget(
              item: item_,
              listWidgetKey: null,
              searchListWidgetKey: _searchListItemFacturaNotaCreditoWidgetKey,
              selectedItem: (BuildContext itemItemFacturaNotaCreditoWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                item.selected = !item.selected;
                if (item.selected){
                  lItemPickList.add(item);
                }else{
                  ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                        (item){
                      if (item.value.idApi >= 0){
                        return item.value.idApi == item_.value.idApi;
                      }else{
                        return item.value.id == item_.value.id;
                      }
                    },
                    orElse: () => ItemList<DbObj>( value: ItemFacturaNotaCredito.empty()),
                  );
                  if (encontrado.value.estado != ItemFacturaNotaCredito.empty().estado){
                    lItemPickList.remove(encontrado);
                  }
                }
                widget.setLItem(lItemPickList);
                fSetState();
                _searchListItemFacturaNotaCreditoWidgetKey.currentState?.resetGuardaPosLista();
              },
            );
          },
          fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
            ResultOf<List<ItemFacturaNotaCredito>> result = await servItemFacturaNotaCredito.fetchDataFind(
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
                  title: Text('Agregar ItemFacturaNotaCredito'),
                  content: AgregarItemFacturaWidget(
                      item: null,
                      result: (Result r){
                        res = r;
                        if (r.success){
                          //Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                          Nav.navPop(context: alertDialogContext);
                        }
                        //Navigator.of(context).pop();
                        //Navigator.pop(alertDialogContext);
                      },
                      mostrarCancelar: true) /*CreateEditItemFacturaNotaCreditoWidget(
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
                  )*/
                );
              },
            );
            if (res == null){
              return Result(success: false,);
            }
            return res!;
          },
        );
      },
      selectedItemCard: (BuildContext pickListWidget,  ItemList<DbObj> item_){
        ItemFacturaNotaCredito value = item_.value as ItemFacturaNotaCredito;
        return Card(
          elevation: 4,
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              value.getValueStr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    );
  }
}



class MultiPickList01ItemFacturaNotaCreditoWidget extends StatefulWidget {
  List<ItemList<DbObj>>? Function() getLItem;
  void Function(List<ItemList<DbObj>>? item) setLItem;
  MultiPickList01ItemFacturaNotaCreditoWidget({
    super.key,
    required this.getLItem,
    required this.setLItem,
  });

  @override
  MultiPickList01ItemFacturaNotaCreditoWidgetState createState() => MultiPickList01ItemFacturaNotaCreditoWidgetState();
}

class MultiPickList01ItemFacturaNotaCreditoWidgetState extends State<MultiPickList01ItemFacturaNotaCreditoWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>> _searchListItemFacturaNotaCreditoWidgetKey = GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>>();
  ItemFacturaNotaCredito itemSelect = ItemFacturaNotaCredito.empty();
  ItemFacturaNotaCreditoService servItemFacturaNotaCredito = ItemFacturaNotaCreditoService();

  @override
  void initState() {
    super.initState();
    List<ItemList<DbObj>>? value = widget.getLItem();
    if (value != null){
      lItemPickList = value;
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Result res = Result(success: false);
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickList01Widget(
        lItemPickList: lItemPickList,
        labelText: 'ItemFacturaNotaCredito',
        hintText: 'Seleccione ItemFacturaNotaCredito',
        validator: validateNotEmpty,
        filterList: (BuildContext context, Future<void> Function() onSetState) {
          return Text("Hola");
        },
        selectedItemCard: (BuildContext pickListWidget,  ItemList<DbObj> item_){
          ItemFacturaNotaCredito value = item_.value as ItemFacturaNotaCredito;
          return Card(
            elevation: 4,
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // Cantidad con ancho fijo de 50
                  SizedBox(
                    width: 50,
                    child: Text(
                      value.cantidad.toString(),
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Producto.nombre con Expanded
                  Expanded(
                    child: Text(
                      value.producto.nombre,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis, // Maneja textos largos
                    ),
                  ),
                  // Precio unitario con ancho fijo de 60
                  SizedBox(
                    width: 60,
                    child: Text(
                      value.precioUnitario.toStringAsFixed(2),
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  // Total con ancho fijo de 60
                  SizedBox(
                    width: 60,
                    child: Text(
                      value.total.toStringAsFixed(2),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black),
                    onPressed: () async {
                      await showDialog<String>(
                          context: context,
                          builder: (showDialogContext) {
                            return Padding(
                              padding: EdgeInsets.all(46),
                              child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text("Agregar producto"),
                                        Divider(),
                                        Expanded(
                                          child: AgregarItemFacturaWidget(
                                            item: value,
                                            result: (Result r){
                                              setState(() {

                                              });
                                            },
                                            mostrarCancelar: true)
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            );
                          }
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () async {
                      final List<ItemList<DbObj>>? lis = widget.getLItem() ?? [];
                      lis!.removeWhere((item) => item.value.idApi == value.idApi);
                      widget.setLItem(lis);
                      setState(() {

                      });
                    },
                  ),
                ],
              )
            ),
          );
        },
      selectItem: (BuildContext context) async {
        await showDialog<String>(
            context: context,
            builder: (showDialogContext) {
              return Padding(
                  padding: EdgeInsets.all(46),
                child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                    child: Column(
                  children: [
                  Text("Agregar producto"),
                  Divider(),
                  Expanded(
                      child: AgregarItemFacturaWidget(
                          item: null,
                          result: (Result r){
                            res = r;
                            if (r.success){
                              List<ItemList<DbObj>>? lis = widget.getLItem() ?? [];
                              lis.add(ItemList<DbObj>(value: r.value));
                              widget.setLItem(lis);
                            }
                            setState(() {

                            });
                            //Navigator.of(context).pop();
                            //Navigator.pop(alertDialogContext);
                          },
                          mostrarCancelar: true)
                  )
                  ],
                ),
                  )
                ),
              );
            }
        );


      },
    );
  }
}