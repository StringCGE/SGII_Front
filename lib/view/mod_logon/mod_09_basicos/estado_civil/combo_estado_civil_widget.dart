import 'package:flutter/material.dart';
import 'package:sgii_front/model/basicos/cls_estado_civil.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_estado_civil.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboEstadoCivilWidget extends StatefulWidget {
  EstadoCivil? Function() getItem;
  void Function(EstadoCivil? item) setItem;
  ComboEstadoCivilWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboEstadoCivilWidgetState createState() => ComboEstadoCivilWidgetState();
}

class ComboEstadoCivilWidgetState extends State<ComboEstadoCivilWidget> {
  final TextEditingController _itemController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return ComboWidget<EstadoCivil>(
      labelText: 'EstadoCivil',
      hintText: 'Seleccione el EstadoCivil',
      controller: _itemController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as EstadoCivil;
        widget.setItem(value);
        _itemController.text = value!.nombre;
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        EstadoCivil item = item_.value as EstadoCivil;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          EstadoCivil aux = value!;
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
        ResultOf<List<EstadoCivil>> result = await servEstadoCivil.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}