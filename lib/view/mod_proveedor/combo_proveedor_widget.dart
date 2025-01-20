import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_proveedor.dart';
import 'package:sgii_front/service/serv_proveedor.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboProveedorWidget extends StatefulWidget {
  Proveedor? Function() getItem;
  void Function(Proveedor? item) setItem;
  ComboProveedorWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboProveedorWidgetState createState() => ComboProveedorWidgetState();
}

class ComboProveedorWidgetState extends State<ComboProveedorWidget> {
  final TextEditingController _proveedorController = TextEditingController();
  Proveedor proveedorSelect = Proveedor.empty();
  ProveedorService servProveedor = ProveedorService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _proveedorController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Proveedor? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<Proveedor>(
      labelText: 'Proveedor',
      hintText: 'Seleccione el Proveedor',
      controller: _proveedorController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as Proveedor;
        widget.setItem(value);
        _proveedorController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        Proveedor item = item_.value as Proveedor;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          Proveedor aux = value!;
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
        ResultOf<List<Proveedor>> result = await servProveedor.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
