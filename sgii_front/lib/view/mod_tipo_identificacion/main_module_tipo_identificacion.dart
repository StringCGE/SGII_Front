import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_tipo_identificacion/filter_list_tipo_identificacion_widget.dart';

class MainModuleTipoIdentificacion extends StatefulWidget {

  MainModuleTipoIdentificacion({
    super.key,
  });

  @override
  MainModuleTipoIdentificacionState createState() => MainModuleTipoIdentificacionState();
}

class MainModuleTipoIdentificacionState extends State<MainModuleTipoIdentificacion> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleTipoIdentificacion oldWidget) {
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
                Text('Lista de tipo de identificacion'),
              ],
            ),
            Expanded(
              child: FilterListTipoIdentificacionWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}