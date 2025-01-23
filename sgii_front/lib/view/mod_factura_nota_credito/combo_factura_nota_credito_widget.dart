import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_factura_nota_credito.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboFacturaNotaCreditoWidget extends StatefulWidget {
  FacturaNotaCredito? Function() getItem;
  void Function(FacturaNotaCredito? item) setItem;
  ComboFacturaNotaCreditoWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboFacturaNotaCreditoWidgetState createState() => ComboFacturaNotaCreditoWidgetState();
}

class ComboFacturaNotaCreditoWidgetState extends State<ComboFacturaNotaCreditoWidget> {
  final TextEditingController _facturaNotaCreditoController = TextEditingController();
  FacturaNotaCredito facturaNotaCreditoSelect = FacturaNotaCredito.empty();
  FacturaNotaCreditoService servFacturaNotaCredito = FacturaNotaCreditoService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _facturaNotaCreditoController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  FacturaNotaCredito? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<FacturaNotaCredito>(
      labelText: 'FacturaNotaCredito',
      hintText: 'Seleccione el FacturaNotaCredito',
      controller: _facturaNotaCreditoController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as FacturaNotaCredito;
        widget.setItem(value);
        _facturaNotaCreditoController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        FacturaNotaCredito item = item_.value as FacturaNotaCredito;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          FacturaNotaCredito aux = value!;
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
        ResultOf<List<FacturaNotaCredito>> result = await servFacturaNotaCredito.fetchDataFind(offset, take, null);
        return result;
      },
    );
  }
}
