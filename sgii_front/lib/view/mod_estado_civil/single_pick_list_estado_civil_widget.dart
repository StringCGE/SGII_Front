import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_estado_civil.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_estado_civil.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/pick_list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_estado_civil/create_edit_estado_civil_widget.dart';
import 'package:sgii_front/view/mod_estado_civil/item_estado_civil_widget.dart';


class SinglePickListEstadoCivilWidget extends StatefulWidget {
  final EstadoCivil? Function() getItem;
  final void Function(EstadoCivil? item) setItem;
  final String labelText;
  final String hintText;
  final String addtext;
  SinglePickListEstadoCivilWidget({
    super.key,
    required this.getItem,
    required this.setItem,
    required this.labelText,
    required this.hintText,
    required this.addtext,
  });

  @override
  SinglePickListEstadoCivilWidgetState createState() => SinglePickListEstadoCivilWidgetState();
}

class SinglePickListEstadoCivilWidgetState extends State<SinglePickListEstadoCivilWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<EstadoCivil>> _searchListEstadoCivilWidgetKey = GlobalKey<SearchListWidgetState<EstadoCivil>>();
  EstadoCivil itemSelect = EstadoCivil.empty();
  EstadoCivilService servEstadoCivil = EstadoCivilService();

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
  EstadoCivil? value;
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickWidget(
        lItemPickList: lItemPickList,
        labelText: widget.labelText,
        hintText: widget.hintText,
        validator: validateNotEmpty,
        filterList: (BuildContext context, Future<void> Function() onSetState) {
          return SearchListWidget<EstadoCivil>(
            key: _searchListEstadoCivilWidgetKey,
            itemCard: (BuildContext context, ItemList<DbObj> item_) {
              ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                    (item){
                  if (item.value.idApi >= 0){
                    return item.value.idApi == item_.value.idApi;
                  }else{
                    return item.value.id == item_.value.id;
                  }
                },
                orElse: () => ItemList<DbObj>( value: EstadoCivil.empty()),
              );
              if (encontrado.value.estado != EstadoCivil.empty().estado){
                item_.selected = encontrado.selected;
              }else{
                item_.selected = false;
              }
              return ItemEstadoCivilWidget(
                item: item_,
                listWidgetKey: null,
                searchListWidgetKey: _searchListEstadoCivilWidgetKey,
                selectedItem: (BuildContext itemEstadoCivilWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                  item.selected = !item.selected;
                  ItemList<DbObj>? itemAnt;
                  if (lItemPickList.isNotEmpty){
                    itemAnt = lItemPickList.elementAt(0);
                    itemAnt.selected = false;
                  }
                  if (item.selected){
                    lItemPickList.clear();
                    lItemPickList.add(item);
                    widget.setItem(item.value as EstadoCivil);
                  }else{
                    lItemPickList.remove(item);
                  }
                  fSetState();
                  _searchListEstadoCivilWidgetKey.currentState?.resetGuardaPosLista();
                },
              );
            },
            fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
              ResultOf<List<EstadoCivil>> result = await servEstadoCivil.fetchDataFind(
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
                    content: CreateEditEstadoCivilWidget(
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
          EstadoCivil value = item_.value as EstadoCivil;
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