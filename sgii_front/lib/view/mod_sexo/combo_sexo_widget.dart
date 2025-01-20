import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_sexo.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_sexo.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';


class ComboSexoWidget extends StatefulWidget {
  Sexo? Function() getItem;
  void Function(Sexo? item) setItem;
  ComboSexoWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboSexoWidgetState createState() => ComboSexoWidgetState();
}

class ComboSexoWidgetState extends State<ComboSexoWidget> {
  final TextEditingController _itemController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return ComboWidget<Sexo>(
      labelText: 'Sexo',
      hintText: 'Seleccione el Sexo',
      controller: _itemController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as Sexo;
        widget.setItem(value);
        _itemController.text = value!.nombre;
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        Sexo item = item_.value as Sexo;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          Sexo aux = value!;
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
          child: Text(item.nombre),
        );
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<Sexo>> result = await servSexo.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}