import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_proveedor/filter_list_proveedor_widget.dart';

class MainModuleProveedor extends StatefulWidget {

  MainModuleProveedor({
    super.key,
  });

  @override
  MainModuleProveedorState createState() => MainModuleProveedorState();
}

class MainModuleProveedorState extends State<MainModuleProveedor> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleProveedor oldWidget) {
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
              child: FilterListProveedorWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}