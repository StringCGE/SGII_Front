import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_estado_civil/filter_list_estado_civil_widget.dart';

class MainModuleEstadoCivil extends StatefulWidget {

  MainModuleEstadoCivil({
    super.key,
  });

  @override
  MainModuleEstadoCivilState createState() => MainModuleEstadoCivilState();
}

class MainModuleEstadoCivilState extends State<MainModuleEstadoCivil> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void didUpdateWidget(covariant MainModuleEstadoCivil oldWidget) {
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
                Text("Lista de Estado civil"),
              ],
            ),
            Expanded(
              child: FilterListEstadoCivilWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }

}


