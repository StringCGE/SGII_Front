import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/filter_list_factura_nota_credito_widget.dart';

class MainModuleFacturaNotaCredito extends StatefulWidget {

  MainModuleFacturaNotaCredito({
    super.key,
  });

  @override
  MainModuleFacturaNotaCreditoState createState() => MainModuleFacturaNotaCreditoState();
}

class MainModuleFacturaNotaCreditoState extends State<MainModuleFacturaNotaCredito> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleFacturaNotaCredito oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('Lista de personas'),
              ],
            ),
            Expanded(
              child: FilterListFacturaNotaCreditoWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}