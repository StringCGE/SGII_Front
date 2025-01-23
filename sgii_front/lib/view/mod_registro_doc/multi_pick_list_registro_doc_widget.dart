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

class MultiPickListRegistroDocWidget extends StatefulWidget {
  List<ItemList<DbObj>>? Function() getLItem;
  void Function(List<ItemList<DbObj>>? item) setLItem;
  MultiPickListRegistroDocWidget({
    super.key,
    required this.getLItem,
    required this.setLItem,
  });

  @override
  MultiPickListRegistroDocWidgetState createState() => MultiPickListRegistroDocWidgetState();
}

class MultiPickListRegistroDocWidgetState extends State<MultiPickListRegistroDocWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<RegistroDoc>> _searchListRegistroDocWidgetKey = GlobalKey<SearchListWidgetState<RegistroDoc>>();
  RegistroDoc itemSelect = RegistroDoc.empty();
  RegistroDocService servRegistroDoc = RegistroDocService();

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
      labelText: 'RegistroDoc',
      hintText: 'Seleccione RegistroDoc',
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
                    orElse: () => ItemList<DbObj>( value: RegistroDoc.empty()),
                  );
                  if (encontrado.value.estado != RegistroDoc.empty().estado){
                    lItemPickList.remove(encontrado);
                  }
                }
                widget.setLItem(lItemPickList);
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
                  title: Text('Agregar RegistroDoc'),
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