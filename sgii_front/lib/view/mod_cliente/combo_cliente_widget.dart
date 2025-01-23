import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_cliente.dart';
import 'package:sgii_front/service/serv_cliente.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/combo_widget.dart';

class ComboClienteWidget extends StatefulWidget {
  Cliente? Function() getItem;
  void Function(Cliente? item) setItem;
  ComboClienteWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  ComboClienteWidgetState createState() => ComboClienteWidgetState();
}

class ComboClienteWidgetState extends State<ComboClienteWidget> {
  final TextEditingController _clienteController = TextEditingController();
  Cliente clienteSelect = Cliente.empty();
  ClienteService servCliente = ClienteService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _clienteController.text = value!.getValueStr();
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Cliente? value;
  @override
  Widget build(BuildContext context) {
    return ComboWidget<Cliente>(
      labelText: 'Cliente',
      hintText: 'Seleccione el Cliente',
      controller: _clienteController,
      validator: validateNotEmpty,
      onSelectedItem: (ItemList<DbObj> item_){
        value = item_.value as Cliente;
        widget.setItem(value);
        _clienteController.text = value!.getValueStr();
      },
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        Cliente item = item_.value as Cliente;
        Color backColor = Colors.white60;
        value = widget.getItem();
        if (value != null){
          Cliente aux = value!;
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
        ResultOf<List<Cliente>> result = await servCliente.fetchDataFind(offset, take, null, null);
        return result;
      },
    );
  }
}
