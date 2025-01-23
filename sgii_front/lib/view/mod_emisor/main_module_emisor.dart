import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_emisor/filter_list_emisor_widget.dart';

class MainModuleEmisor extends StatefulWidget {

  MainModuleEmisor({
    super.key,
  });

  @override
  MainModuleEmisorState createState() => MainModuleEmisorState();
}

class MainModuleEmisorState extends State<MainModuleEmisor> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleEmisor oldWidget) {
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
              child: FilterListEmisorWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}