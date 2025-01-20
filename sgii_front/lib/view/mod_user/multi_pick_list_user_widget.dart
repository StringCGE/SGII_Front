import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_user.dart';
import 'package:sgii_front/service/serv_user.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/pick_list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_user/create_edit_user_widget.dart';
import 'package:sgii_front/view/mod_user/item_user_widget.dart';

class MultiPickListUserWidget extends StatefulWidget {
  List<ItemList<DbObj>>? Function() getLItem;
  void Function(List<ItemList<DbObj>>? item) setLItem;
  MultiPickListUserWidget({
    super.key,
    required this.getLItem,
    required this.setLItem,
  });

  @override
  MultiPickListUserWidgetState createState() => MultiPickListUserWidgetState();
}

class MultiPickListUserWidgetState extends State<MultiPickListUserWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<User>> _searchListUserWidgetKey = GlobalKey<SearchListWidgetState<User>>();
  User itemSelect = User.empty();
  UserService servUser = UserService();

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
      labelText: 'User',
      hintText: 'Seleccione una persona',
      validator: validateNotEmpty,
      filterList: (BuildContext context, Future<void> Function() onSetState) {
        return SearchListWidget<User>(
          key: _searchListUserWidgetKey,
          itemCard: (BuildContext context, ItemList<DbObj> item_) {
            ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                  (item){
                if (item.value.idApi >= 0){
                  return item.value.idApi == item_.value.idApi;
                }else{
                  return item.value.id == item_.value.id;
                }
              },
              orElse: () => ItemList<DbObj>( value: User.empty()),
            );
            if (encontrado.value.estado != User.empty().estado){
              item_.selected = encontrado.selected;
            }else{
              item_.selected = false;
            }
            return ItemUserWidget(
              item: item_,
              listWidgetKey: null,
              searchListWidgetKey: _searchListUserWidgetKey,
              selectedItem: (BuildContext itemUserWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
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
                    orElse: () => ItemList<DbObj>( value: User.empty()),
                  );
                  if (encontrado.value.estado != User.empty().estado){
                    lItemPickList.remove(encontrado);
                  }
                }
                widget.setLItem(lItemPickList);
                fSetState();
                _searchListUserWidgetKey.currentState?.resetGuardaPosLista();
              },
            );
          },
          fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
            ResultOf<List<User>> result = await servUser.fetchDataFind(
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
                  title: Text('Agregar User'),
                  content: CreateEditUserWidget(
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
        User value = item_.value as User;
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