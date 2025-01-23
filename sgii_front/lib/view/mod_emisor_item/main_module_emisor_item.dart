import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_emisor_item/filter_list_emisor_item_widget.dart';

class MainModuleEmisorItem extends StatefulWidget {

  MainModuleEmisorItem({
    super.key,
  });

  @override
  MainModuleEmisorItemState createState() => MainModuleEmisorItemState();
}

class MainModuleEmisorItemState extends State<MainModuleEmisorItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleEmisorItem oldWidget) {
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
              child: FilterListEmisorItemWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}