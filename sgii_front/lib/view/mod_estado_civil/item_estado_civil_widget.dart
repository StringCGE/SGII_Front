import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_estado_civil.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_estado_civil.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_estado_civil/create_edit_estado_civil_widget.dart';


class ItemEstadoCivilWidget extends StatefulWidget {
  final ItemList<DbObj> item;
  final GlobalKey<SearchListWidgetState<EstadoCivil>>? searchListWidgetKey;
  final GlobalKey<ListWidgetState<EstadoCivil>>? listWidgetKey;
  final Future<void> Function(BuildContext context, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  ItemEstadoCivilWidget({
    super.key,
    required this.item,
    required this.searchListWidgetKey,
    required this.listWidgetKey,
    required this.selectedItem,
  });

  ItemEstadoCivilWidgetState createState() => ItemEstadoCivilWidgetState();
}
class ItemEstadoCivilWidgetState extends State<ItemEstadoCivilWidget>{
  EstadoCivilService serv = EstadoCivilService();
  @override
  Widget build(BuildContext context) {
    EstadoCivil value = widget.item.value as EstadoCivil;
    return Card(
      color: widget.item.selected? Colors.blue[100]: null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${value.id} - (${value.idApi}) - ${value.nombre}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Estado: ${value.estado}'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Detalles del EstadoCivil'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${value.id}'),
                            Text('ID API: ${value.idApi}'),
                            Text('Fecha de Registro: ${value.dtReg}'),
                            Text('Registrado por: ${value.idPersReg}'),
                            Text('Estado: ${value.estado}'),
                            Text('Nombre: ${value.nombre}'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cerrar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                Result? res;
                await showDialog(
                  context: context,
                  builder: (BuildContext alertDialogContext) {
                    return AlertDialog(
                      title: Text('Editar EstadoCivil'),
                      content: CreateEditEstadoCivilWidget(
                        mostrarCancelar: true,
                        item: value,
                        result: (Result r) {
                          res = r;
                          if (r.success) {
                            widget.searchListWidgetKey?.currentState?.resetGuardaPosLista();
                            widget.listWidgetKey?.currentState?.resetGuardaPosLista();
                            Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                Info info = Info();
                await info.showLoadingMask(context);
                Result res = await serv.deleteItem(value);
                await info.hideLoadingMask(context);
                if (res.success) {
                  widget.searchListWidgetKey?.currentState?.resetGuardaPosLista();
                  widget.listWidgetKey?.currentState?.resetGuardaPosLista();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
