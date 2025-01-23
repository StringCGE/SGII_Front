import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_emisor_establecimiento/filter_list_emisor_establecimiento_widget.dart';

class MainModuleEmisorEstablecimiento extends StatefulWidget {

  MainModuleEmisorEstablecimiento({
    super.key,
  });

  @override
  MainModuleEmisorEstablecimientoState createState() => MainModuleEmisorEstablecimientoState();
}

class MainModuleEmisorEstablecimientoState extends State<MainModuleEmisorEstablecimiento> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleEmisorEstablecimiento oldWidget) {
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
              child: FilterListEmisorEstablecimientoWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}