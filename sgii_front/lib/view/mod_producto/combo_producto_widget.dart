import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_producto.dart';
import 'package:sgii_front/service/serv_producto.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboProductoWidget extends StatefulWidget {
  Producto? Function() getItem;
  void Function(Producto? item) setItem;
  ComboProductoWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboProductoWidgetState createState() => ComboProductoWidgetState();
}

class ComboProductoWidgetState extends State<ComboProductoWidget> {
  final TextEditingController _productoController = TextEditingController();
  Producto productoSelect = Producto.empty();
  ProductoService servProducto = ProductoService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _productoController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Producto? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<Producto>(
      labelText: 'Producto',
      hintText: 'Seleccione el Producto',
      controller: _productoController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as Producto;
        widget.setItem(value);
        _productoController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        Producto item = item_.value as Producto;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          Producto aux = value!;
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
        ResultOf<List<Producto>> result = await servProducto.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
