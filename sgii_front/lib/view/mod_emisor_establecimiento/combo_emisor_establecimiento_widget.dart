import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor_establecimiento.dart';
import 'package:sgii_front/service/serv_emisor_establecimiento.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboEmisorEstablecimientoWidget extends StatefulWidget {
  EmisorEstablecimiento? Function() getItem;
  void Function(EmisorEstablecimiento? item) setItem;
  ComboEmisorEstablecimientoWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboEmisorEstablecimientoWidgetState createState() => ComboEmisorEstablecimientoWidgetState();
}

class ComboEmisorEstablecimientoWidgetState extends State<ComboEmisorEstablecimientoWidget> {
  final TextEditingController _emisorEstablecimientoController = TextEditingController();
  EmisorEstablecimiento emisorEstablecimientoSelect = EmisorEstablecimiento.empty();
  EmisorEstablecimientoService servEmisorEstablecimiento = EmisorEstablecimientoService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _emisorEstablecimientoController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  EmisorEstablecimiento? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<EmisorEstablecimiento>(
      labelText: 'EmisorEstablecimiento',
      hintText: 'Seleccione el EmisorEstablecimiento',
      controller: _emisorEstablecimientoController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as EmisorEstablecimiento;
        widget.setItem(value);
        _emisorEstablecimientoController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        EmisorEstablecimiento item = item_.value as EmisorEstablecimiento;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          EmisorEstablecimiento aux = value!;
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
        ResultOf<List<EmisorEstablecimiento>> result = await servEmisorEstablecimiento.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
