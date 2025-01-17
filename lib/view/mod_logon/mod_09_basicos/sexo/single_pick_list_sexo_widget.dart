import 'package:flutter/material.dart';import 'package:sgii_front/model/basicos/cls_sexo.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_sexo.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';
import 'package:sgii_front/util/my_widget/pick_list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/sexo/create_edit_sexo_widget.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/sexo/filter_list_sexo_widget.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/sexo/item_sexo_widget.dart';

class SinglePickListSexoWidget extends StatefulWidget {
  Sexo? Function() getItem;
  void Function(Sexo? item) setItem;
  SinglePickListSexoWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  SinglePickListSexoWidgetState createState() => SinglePickListSexoWidgetState();
}

class SinglePickListSexoWidgetState extends State<SinglePickListSexoWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<Sexo>> _searchListSexoWidgetKey = GlobalKey<SearchListWidgetState<Sexo>>();
  Sexo itemSelect = Sexo.empty();
  SexoService servSexo = SexoService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _itemController.text = value!.nombre;
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Sexo? value;
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickListWidget(
        lItemPickList: lItemPickList,
        labelText: 'Sexo',
        hintText: 'Seleccione una persona',
        validator: validateNotEmpty,
        filterList: (BuildContext context, Future<void> Function() onSetState) {
          return SearchListWidget<Sexo>(
            key: _searchListSexoWidgetKey,
            itemCard: (BuildContext context, ItemList<DbObj> item_) {
              ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                    (item){
                  if (item.value.idApi >= 0){
                    return item.value.idApi == item_.value.idApi;
                  }else{
                    return item.value.id == item_.value.id;
                  }
                },
                orElse: () => ItemList<DbObj>( value: Sexo.empty()),
              );
              if (encontrado.value.estado != Sexo.empty().estado){
                item_.selected = encontrado.selected;
              }else{
                item_.selected = false;
              }
              return ItemSexoWidget(
                item: item_,
                listWidgetKey: null,
                searchListWidgetKey: _searchListSexoWidgetKey,
                selectedItem: (BuildContext itemSexoWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                  item.selected = !item.selected;
                  ItemList<DbObj>? itemAnt;
                  if (lItemPickList.isNotEmpty){
                    itemAnt = lItemPickList.elementAt(0);
                    itemAnt.selected = false;
                  }
                  if (item.selected){
                    lItemPickList.clear();
                    lItemPickList.add(item);
                    widget.setItem(item.value as Sexo);
                  }else{
                    lItemPickList.remove(item);
                  }
                  fSetState();
                  _searchListSexoWidgetKey.currentState?.resetGuardaPosLista();
                },
              );
            },
            fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
              ResultOf<List<Sexo>> result = await servSexo.fetchDataFind(
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
                    title: Text('Agregar Sexo'),
                    content: CreateEditSexoWidget(
                        mostrarCancelar: true,
                        item:null,
                        result: (Result r){
                          res = r;
                          if (r.success){
                            Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
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
          Sexo value = item_.value as Sexo;
          return Card(
            elevation: 4,
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                value.nombre,
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