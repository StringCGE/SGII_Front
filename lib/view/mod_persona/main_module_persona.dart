import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_persona/filter_list_persona_widget.dart';

class MainModulePersona extends StatefulWidget {

  MainModulePersona({
    super.key,
  });

  @override
  MainModulePersonaState createState() => MainModulePersonaState();
}

class MainModulePersonaState extends State<MainModulePersona> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModulePersona oldWidget) {
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
              child: FilterListPersonaWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}