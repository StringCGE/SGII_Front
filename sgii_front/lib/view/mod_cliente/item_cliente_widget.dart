import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_cliente.dart';
import 'package:sgii_front/service/serv_cliente.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_cliente/create_edit_cliente_widget.dart';

class ItemClienteWidget extends StatefulWidget {
  final ItemList<DbObj> item;
  final GlobalKey<SearchListWidgetState<Cliente>>? searchListWidgetKey;
  final GlobalKey<ListWidgetState<Cliente>>? listWidgetKey;
  final Future<void> Function(BuildContext context, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  ItemClienteWidget({
    super.key,
    required this.item,
    required this.searchListWidgetKey,
    required this.listWidgetKey,
    required this.selectedItem,
  });

  ItemClienteWidgetState createState() => ItemClienteWidgetState();
}
class ItemClienteWidgetState extends State<ItemClienteWidget>{
  ClienteService serv = ClienteService();

  @override
  Widget build(BuildContext context) {
    Cliente value = widget.item.value as Cliente;
    widget.item.reset = (){
      if (mounted) {
        setState(() {});
      }
    };
    return GestureDetector(
        onTap: (){
          widget.selectedItem(context, widget.item, (){
            if (mounted) {
              setState(() {});
            }
          });
          //Navigator.pop(context);
          //Navigator.popUntil(showDialogContext, (route) => route.isFirst);
        },
        child: Card(
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
                        '${value.id} - (${value.idApi}) - ${value.getValueStr()}',
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
                          title: Text('Detalles del Cliente'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${value.id}'),
                                Text('ID API: ${value.idApi}'),
                                Text('Fecha de Registro: ${value.dtReg}'),
                                Text('Registrado por: ${value.idPersReg}'),
                                Text('Estado: ${value.estado}'),
                                Text('Persona: ${value.persona.getValueStr()}'),
                                Text('Identificacion: ${value.identificacion}'),
                                Text('TipoIdentificacion: ${value.tipoIdentificacion.getValueStr()}'),
                                Text('Telefono: ${value.telefono}'),
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
                          title: Text('Editar Cliente'),
                          content: CreateEditClienteWidget(
                            mostrarCancelar: true,
                            item: value,
                            result: (Result r) {
                              res = r;
                              if (r.success) {
                                widget.searchListWidgetKey?.currentState?.resetGuardaPosLista();
                                widget.listWidgetKey?.currentState?.resetGuardaPosLista();
                                
                                
                                //Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                                Nav.navPop(context: alertDialogContext);
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
        )
    );
  }
}