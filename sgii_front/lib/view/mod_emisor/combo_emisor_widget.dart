import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor.dart';
import 'package:sgii_front/service/serv_emisor.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboEmisorWidget extends StatefulWidget {
  Emisor? Function() getItem;
  void Function(Emisor? item) setItem;
  ComboEmisorWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboEmisorWidgetState createState() => ComboEmisorWidgetState();
}

class ComboEmisorWidgetState extends State<ComboEmisorWidget> {
  final TextEditingController _emisorController = TextEditingController();
  Emisor emisorSelect = Emisor.empty();
  EmisorService servEmisor = EmisorService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _emisorController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Emisor? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<Emisor>(
      labelText: 'Emisor',
      hintText: 'Seleccione el Emisor',
      controller: _emisorController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as Emisor;
        widget.setItem(value);
        _emisorController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        Emisor item = item_.value as Emisor;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          Emisor aux = value!;
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
        ResultOf<List<Emisor>> result = await servEmisor.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
