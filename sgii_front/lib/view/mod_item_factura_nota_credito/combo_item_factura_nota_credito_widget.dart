import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_item_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_item_factura_nota_credito.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboItemFacturaNotaCreditoWidget extends StatefulWidget {
  ItemFacturaNotaCredito? Function() getItem;
  void Function(ItemFacturaNotaCredito? item) setItem;
  ComboItemFacturaNotaCreditoWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboItemFacturaNotaCreditoWidgetState createState() => ComboItemFacturaNotaCreditoWidgetState();
}

class ComboItemFacturaNotaCreditoWidgetState extends State<ComboItemFacturaNotaCreditoWidget> {
  final TextEditingController _itemFacturaNotaCreditoController = TextEditingController();
  ItemFacturaNotaCredito itemFacturaNotaCreditoSelect = ItemFacturaNotaCredito.empty();
  ItemFacturaNotaCreditoService servItemFacturaNotaCredito = ItemFacturaNotaCreditoService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _itemFacturaNotaCreditoController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  ItemFacturaNotaCredito? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<ItemFacturaNotaCredito>(
      labelText: 'ItemFacturaNotaCredito',
      hintText: 'Seleccione el ItemFacturaNotaCredito',
      controller: _itemFacturaNotaCreditoController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as ItemFacturaNotaCredito;
        widget.setItem(value);
        _itemFacturaNotaCreditoController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        ItemFacturaNotaCredito item = item_.value as ItemFacturaNotaCredito;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          ItemFacturaNotaCredito aux = value!;
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
        ResultOf<List<ItemFacturaNotaCredito>> result = await servItemFacturaNotaCredito.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
