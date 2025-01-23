import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/filter_list_item_factura_nota_credito_widget.dart';

class MainModuleItemFacturaNotaCredito extends StatefulWidget {

  MainModuleItemFacturaNotaCredito({
    super.key,
  });

  @override
  MainModuleItemFacturaNotaCreditoState createState() => MainModuleItemFacturaNotaCreditoState();
}

class MainModuleItemFacturaNotaCreditoState extends State<MainModuleItemFacturaNotaCredito> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleItemFacturaNotaCredito oldWidget) {
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
              child: FilterListItemFacturaNotaCreditoWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}