import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_nacionalidad.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';
import 'package:sgii_front/util/my_widget/pick_list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';
import 'package:sgii_front/view/mod_nacionalidad/create_edit_nacionalidad_widget.dart';
import 'package:sgii_front/view/mod_nacionalidad/filter_list_nacionalidad_widget.dart';
import 'package:sgii_front/view/mod_nacionalidad/item_nacionalidad_widget.dart';


class SinglePickListNacionalidadWidget extends StatefulWidget {
  Nacionalidad? Function() getItem;
  void Function(Nacionalidad? item) setItem;
  SinglePickListNacionalidadWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  SinglePickListNacionalidadWidgetState createState() => SinglePickListNacionalidadWidgetState();
}

class SinglePickListNacionalidadWidgetState extends State<SinglePickListNacionalidadWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<Nacionalidad>> _searchListNacionalidadWidgetKey = GlobalKey<SearchListWidgetState<Nacionalidad>>();
  Nacionalidad itemSelect = Nacionalidad.empty();
  NacionalidadService servNacionalidad = NacionalidadService();

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
  Nacionalidad? value;
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickListWidget(
        lItemPickList: lItemPickList,
        labelText: 'Nacionalidad',
        hintText: 'Seleccione una persona',
        validator: validateNotEmpty,
        filterList: (BuildContext context, Future<void> Function() onSetState) {
          return SearchListWidget<Nacionalidad>(
            key: _searchListNacionalidadWidgetKey,
            itemCard: (BuildContext context, ItemList<DbObj> item_) {
              ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                    (item){
                  if (item.value.idApi >= 0){
                    return item.value.idApi == item_.value.idApi;
                  }else{
                    return item.value.id == item_.value.id;
                  }
                },
                orElse: () => ItemList<DbObj>( value: Nacionalidad.empty()),
              );
              if (encontrado.value.estado != Nacionalidad.empty().estado){
                item_.selected = encontrado.selected;
              }else{
                item_.selected = false;
              }
              return ItemNacionalidadWidget(
                item: item_,
                listWidgetKey: null,
                searchListWidgetKey: _searchListNacionalidadWidgetKey,
                selectedItem: (BuildContext itemNacionalidadWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                  item.selected = !item.selected;
                  ItemList<DbObj>? itemAnt;
                  if (lItemPickList.isNotEmpty){
                    itemAnt = lItemPickList.elementAt(0);
                    itemAnt.selected = false;
                  }
                  if (item.selected){
                    lItemPickList.clear();
                    lItemPickList.add(item);
                    widget.setItem(item.value as Nacionalidad);
                  }else{
                    lItemPickList.remove(item);
                  }
                  fSetState();
                  _searchListNacionalidadWidgetKey.currentState?.resetGuardaPosLista();
                },
              );
            },
            fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
              ResultOf<List<Nacionalidad>> result = await servNacionalidad.fetchDataFind(
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
                    title: Text('Agregar Nacionalidad'),
                    content: CreateEditNacionalidadWidget(
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
          Nacionalidad value = item_.value as Nacionalidad;
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