import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_nacionalidad.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_nacionalidad.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';


class ComboNacionalidadWidget extends StatefulWidget {
  Nacionalidad? Function() getItem;
  void Function(Nacionalidad? item) setItem;
  ComboNacionalidadWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboNacionalidadWidgetState createState() => ComboNacionalidadWidgetState();
}

class ComboNacionalidadWidgetState extends State<ComboNacionalidadWidget> {
  final TextEditingController _itemController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return ComboWidget<Nacionalidad>(
      labelText: 'Nacionalidad',
      hintText: 'Seleccione el Nacionalidad',
      controller: _itemController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as Nacionalidad;
        widget.setItem(value);
        _itemController.text = value!.nombre;
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        Nacionalidad item = item_.value as Nacionalidad;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          Nacionalidad aux = value!;
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
        ResultOf<List<Nacionalidad>> result = await servNacionalidad.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}