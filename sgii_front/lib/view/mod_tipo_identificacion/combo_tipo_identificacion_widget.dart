import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_tipo_identificacion.dart';
import 'package:sgii_front/service/serv_tipo_identificacion.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboTipoIdentificacionWidget extends StatefulWidget {
  TipoIdentificacion? Function() getItem;
  void Function(TipoIdentificacion? item) setItem;
  ComboTipoIdentificacionWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboTipoIdentificacionWidgetState createState() => ComboTipoIdentificacionWidgetState();
}

class ComboTipoIdentificacionWidgetState extends State<ComboTipoIdentificacionWidget> {
  final TextEditingController _tipoIdentificacionController = TextEditingController();
  TipoIdentificacion tipoIdentificacionSelect = TipoIdentificacion.empty();
  TipoIdentificacionService servTipoIdentificacion = TipoIdentificacionService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _tipoIdentificacionController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  TipoIdentificacion? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<TipoIdentificacion>(
      labelText: 'TipoIdentificacion',
      hintText: 'Seleccione el TipoIdentificacion',
      controller: _tipoIdentificacionController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as TipoIdentificacion;
        widget.setItem(value);
        _tipoIdentificacionController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        TipoIdentificacion item = item_.value as TipoIdentificacion;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          TipoIdentificacion aux = value!;
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
        ResultOf<List<TipoIdentificacion>> result = await servTipoIdentificacion.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
