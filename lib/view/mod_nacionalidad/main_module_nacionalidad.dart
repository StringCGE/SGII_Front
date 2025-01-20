import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_nacionalidad/filter_list_nacionalidad_widget.dart';

class MainModuleNacionalidad extends StatefulWidget {

  MainModuleNacionalidad({
    super.key,
  });

  @override
  MainModuleNacionalidadState createState() => MainModuleNacionalidadState();
}

class MainModuleNacionalidadState extends State<MainModuleNacionalidad> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void didUpdateWidget(covariant MainModuleNacionalidad oldWidget) {
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
                Text("Lista de Nacionalidad"),
              ],
            ),
            Expanded(
              child: FilterListNacionalidadWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }

}


