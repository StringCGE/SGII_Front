import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/pick_list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_persona/create_edit_persona_widget.dart';
import 'package:sgii_front/view/mod_persona/item_persona_widget.dart';

class SinglePickListPersonaWidget extends StatefulWidget {
  Persona? Function() getItem;
  void Function(Persona? item) setItem;
  SinglePickListPersonaWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  SinglePickListPersonaWidgetState createState() =>SinglePickListPersonaWidgetState();
}

class SinglePickListPersonaWidgetState extends State<SinglePickListPersonaWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<Persona>> _searchListPersonaWidgetKey = GlobalKey<SearchListWidgetState<Persona>>();
  Persona itemSelect = Persona.empty();
  PersonaService servPersona = PersonaService();

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
  Persona? value;
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickListWidget(
        lItemPickList: lItemPickList,
        labelText: 'Persona',
        hintText: 'Seleccione una persona',
        validator: validateNotEmpty,
        filterList: (BuildContext context, Future<void> Function() onSetState) {
          return SearchListWidget<Persona>(
            key: _searchListPersonaWidgetKey,
            itemCard: (BuildContext context, ItemList<DbObj> item_) {
              ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                    (item){
                  if (item.value.idApi >= 0){
                    return item.value.idApi == item_.value.idApi;
                  }else{
                    return item.value.id == item_.value.id;
                  }
                },
                orElse: () => ItemList<DbObj>( value: Persona.empty()),
              );
              if (encontrado.value.estado != Persona.empty().estado){
                item_.selected = encontrado.selected;
              }else{
                item_.selected = false;
              }
              return ItemPersonaWidget(
                item: item_,
                listWidgetKey: null,
                searchListWidgetKey: _searchListPersonaWidgetKey,
                selectedItem: (BuildContext itemPersonaWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                  item.selected = !item.selected;
                  ItemList<DbObj>? itemAnt;
                  if (lItemPickList.isNotEmpty){
                    itemAnt = lItemPickList.elementAt(0);
                    itemAnt.selected = false;
                  }
                  if (item.selected){
                    lItemPickList.clear();
                    lItemPickList.add(item);
                    widget.setItem(item.value as Persona);
                  }else{
                    lItemPickList.remove(item);
                  }
                  fSetState();
                  _searchListPersonaWidgetKey.currentState?.resetGuardaPosLista();
                },
              );
            },
            fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
              ResultOf<List<Persona>> result = await servPersona.fetchDataFind(
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
                    title: Text('Agregar Persona'),
                    content: CreateEditPersonaWidget(
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
          Persona value = item_.value as Persona;
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