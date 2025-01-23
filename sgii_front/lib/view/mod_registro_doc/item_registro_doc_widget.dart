import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_registro_doc.dart';
import 'package:sgii_front/service/serv_registro_doc.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_registro_doc/create_edit_registro_doc_widget.dart';

class ItemRegistroDocWidget extends StatefulWidget {
  final ItemList<DbObj> item;
  final GlobalKey<SearchListWidgetState<RegistroDoc>>? searchListWidgetKey;
  final GlobalKey<ListWidgetState<RegistroDoc>>? listWidgetKey;
  final Future<void> Function(BuildContext context, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  ItemRegistroDocWidget({
    super.key,
    required this.item,
    required this.searchListWidgetKey,
    required this.listWidgetKey,
    required this.selectedItem,
  });

  ItemRegistroDocWidgetState createState() => ItemRegistroDocWidgetState();
}
class ItemRegistroDocWidgetState extends State<ItemRegistroDocWidget>{
  RegistroDocService serv = RegistroDocService();

  @override
  Widget build(BuildContext context) {
    RegistroDoc value = widget.item.value as RegistroDoc;
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
                          title: Text('Detalles del RegistroDoc'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${value.id}'),
                                Text('ID API: ${value.idApi}'),
                                Text('Fecha de Registro: ${value.dtReg}'),
                                Text('Registrado por: ${value.idPersReg}'),
                                Text('Estado: ${value.estado}'),
                                Text('Secuencial: ${value.secuencial}'),
                                Text('RazonSocial: ${value.razonSocial}'),
                                Text('Identificacion: ${value.identificacion}'),
                                Text('FechaEmision: ${value.fechaEmision}'),
                                Text('NumeroGuiaRemision: ${value.numeroGuiaRemision}'),
                                Text('CodigoNumerico: ${value.codigoNumerico}'),
                                Text('Verificador: ${value.verificador}'),
                                Text('DenomComproModif: ${value.denomComproModif}'),
                                Text('NumComproModif: ${value.numComproModif}'),
                                Text('ComproModif: ${value.comproModif}'),
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
                          title: Text('Editar RegistroDoc'),
                          content: CreateEditRegistroDocWidget(
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