import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor_item.dart';
import 'package:sgii_front/service/serv_emisor_item.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboEmisorItemWidget extends StatefulWidget {
  EmisorItem? Function() getItem;
  void Function(EmisorItem? item) setItem;
  ComboEmisorItemWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboEmisorItemWidgetState createState() => ComboEmisorItemWidgetState();
}

class ComboEmisorItemWidgetState extends State<ComboEmisorItemWidget> {
  final TextEditingController _emisorItemController = TextEditingController();
  EmisorItem emisorItemSelect = EmisorItem.empty();
  EmisorItemService servEmisorItem = EmisorItemService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _emisorItemController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  EmisorItem? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<EmisorItem>(
      labelText: 'EmisorItem',
      hintText: 'Seleccione el EmisorItem',
      controller: _emisorItemController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as EmisorItem;
        widget.setItem(value);
        _emisorItemController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        EmisorItem item = item_.value as EmisorItem;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          EmisorItem aux = value!;
          if (aux.idApi > 0){//Aqui posible bug
            if (aux.idApi == item.idApi){
              backColor = Colors.blueAccent;
            }
          }else{
            if (aux.idApi == item.idApi){
              backColor = Colors.blueAccent;
            }
          }
        }
        return Container(
          padding: EdgeInsets.all(8),
          color: backColor,
          child: Text(item.getValueStr()),
        );
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<EmisorItem>> result = await servEmisorItem.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
