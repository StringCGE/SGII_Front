import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_registro_doc/filter_list_registro_doc_widget.dart';

class MainModuleRegistroDoc extends StatefulWidget {

  MainModuleRegistroDoc({
    super.key,
  });

  @override
  MainModuleRegistroDocState createState() => MainModuleRegistroDocState();
}

class MainModuleRegistroDocState extends State<MainModuleRegistroDoc> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleRegistroDoc oldWidget) {
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
              child: FilterListRegistroDocWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}