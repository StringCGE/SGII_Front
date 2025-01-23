import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_registro_doc.dart';
import 'package:sgii_front/service/serv_registro_doc.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/pick_list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/create_edit_registro_doc_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/item_registro_doc_widget.dart';

class SinglePickListRegistroDocWidget extends StatefulWidget {
  final RegistroDoc? Function() getItem;
  final void Function(RegistroDoc? item) setItem;
  final String labelText;
  final String hintText;
  final String addtext;
  SinglePickListRegistroDocWidget({
    super.key,
    required this.getItem,
    required this.setItem,
    required this.labelText,
    required this.hintText,
    required this.addtext,
  });

  @override
  SinglePickListRegistroDocWidgetState createState() =>SinglePickListRegistroDocWidgetState();
}

class SinglePickListRegistroDocWidgetState extends State<SinglePickListRegistroDocWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<RegistroDoc>> _searchListRegistroDocWidgetKey = GlobalKey<SearchListWidgetState<RegistroDoc>>();
  RegistroDoc itemSelect = RegistroDoc.empty();
  RegistroDocService servRegistroDoc = RegistroDocService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      lItemPickList.add(ItemList<DbObj>(value: value!));
      _itemController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  RegistroDoc? value;
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickWidget(
        lItemPickList: lItemPickList,
        labelText: widget.labelText,
        hintText: widget.hintText,
        validator: validateNotEmpty,
        filterList: (BuildContext context, Future<void> Function() onSetState) {
          return SearchListWidget<RegistroDoc>(
            key: _searchListRegistroDocWidgetKey,
            itemCard: (BuildContext context, ItemList<DbObj> item_) {
              ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                    (item){
                  if (item.value.idApi >= 0){
                    return item.value.idApi == item_.value.idApi;
                  }else{
                    return item.value.id == item_.value.id;
                  }
                },
                orElse: () => ItemList<DbObj>( value: RegistroDoc.empty()),
              );
              if (encontrado.value.estado != RegistroDoc.empty().estado){
                item_.selected = encontrado.selected;
              }else{
                item_.selected = false;
              }
              return ItemRegistroDocWidget(
                item: item_,
                listWidgetKey: null,
                searchListWidgetKey: _searchListRegistroDocWidgetKey,
                selectedItem: (BuildContext itemRegistroDocWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                  item.selected = !item.selected;
                  ItemList<DbObj>? itemAnt;
                  if (lItemPickList.isNotEmpty){
                    itemAnt = lItemPickList.elementAt(0);
                    itemAnt.selected = false;
                  }
                  if (item.selected){
                    lItemPickList.clear();
                    lItemPickList.add(item);
                    widget.setItem(item.value as RegistroDoc);
                  }else{
                    lItemPickList.remove(item);
                  }
                  fSetState();
                  _searchListRegistroDocWidgetKey.currentState?.resetGuardaPosLista();
                },
              );
            },
            fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
              ResultOf<List<RegistroDoc>> result = await servRegistroDoc.fetchDataFind(
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
                    title: Text(widget.addtext),
                    content: CreateEditRegistroDocWidget(
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
          );
        },
        selectedItemCard: (BuildContext pickListWidget,  ItemList<DbObj> item_){
          RegistroDoc value = item_.value as RegistroDoc;
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