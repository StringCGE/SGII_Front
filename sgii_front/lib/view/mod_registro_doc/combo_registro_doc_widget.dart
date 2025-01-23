import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_registro_doc.dart';
import 'package:sgii_front/service/serv_registro_doc.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboRegistroDocWidget extends StatefulWidget {
  RegistroDoc? Function() getItem;
  void Function(RegistroDoc? item) setItem;
  ComboRegistroDocWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboRegistroDocWidgetState createState() => ComboRegistroDocWidgetState();
}

class ComboRegistroDocWidgetState extends State<ComboRegistroDocWidget> {
  final TextEditingController _registroDocController = TextEditingController();
  RegistroDoc registroDocSelect = RegistroDoc.empty();
  RegistroDocService servRegistroDoc = RegistroDocService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _registroDocController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  RegistroDoc? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<RegistroDoc>(
      labelText: 'RegistroDoc',
      hintText: 'Seleccione el RegistroDoc',
      controller: _registroDocController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as RegistroDoc;
        widget.setItem(value);
        _registroDocController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        RegistroDoc item = item_.value as RegistroDoc;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          RegistroDoc aux = value!;
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
        ResultOf<List<RegistroDoc>> result = await servRegistroDoc.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
