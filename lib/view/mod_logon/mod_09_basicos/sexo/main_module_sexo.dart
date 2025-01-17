import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/sexo/filter_list_sexo_widget.dart';

class MainModuleSexo extends StatefulWidget {

  MainModuleSexo({
    super.key,
  });

  @override
  MainModuleSexoState createState() => MainModuleSexoState();
}

class MainModuleSexoState extends State<MainModuleSexo> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void didUpdateWidget(covariant MainModuleSexo oldWidget) {
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
                Column(
                  children: [
                    Text("Sexo"),
                    Text("Permite administrar las opciones para el campo sexo en otras areas"),
                    Text("Sexo: es uan clasificacion del ser humano, mas no la orientacion sexual"),
                  ],
                )
              ],
            ),
            Expanded(
              child: FilterListSexoWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }

}


