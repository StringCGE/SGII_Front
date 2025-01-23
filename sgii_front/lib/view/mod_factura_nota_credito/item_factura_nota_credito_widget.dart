import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_factura_nota_credito.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/list_widget.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/create_edit_factura_nota_credito_widget.dart';

class ItemFacturaNotaCreditoWidget extends StatefulWidget {
  final ItemList<DbObj> item;
  final GlobalKey<SearchListWidgetState<FacturaNotaCredito>>? searchListWidgetKey;
  final GlobalKey<ListWidgetState<FacturaNotaCredito>>? listWidgetKey;
  final Future<void> Function(BuildContext context, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  ItemFacturaNotaCreditoWidget({
    super.key,
    required this.item,
    required this.searchListWidgetKey,
    required this.listWidgetKey,
    required this.selectedItem,
  });

  ItemFacturaNotaCreditoWidgetState createState() => ItemFacturaNotaCreditoWidgetState();
}
class ItemFacturaNotaCreditoWidgetState extends State<ItemFacturaNotaCreditoWidget>{
  FacturaNotaCreditoService serv = FacturaNotaCreditoService();

  @override
  Widget build(BuildContext context) {
    FacturaNotaCredito value = widget.item.value as FacturaNotaCredito;
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
                          title: Text('Detalles del FacturaNotaCredito'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${value.id}'),
                                Text('ID API: ${value.idApi}'),
                                Text('Fecha de Registro: ${value.dtReg}'),
                                Text('Registrado por: ${value.idPersReg}'),
                                Text('Estado: ${value.estado}'),
                                Text('Emisor: ${value.emisor.getValueStr()}'),
                                Text('RegistroFactura: ${value.registroFactura.getValueStr()}'),
                                Text('Cliente: ${value.cliente.getValueStr()}'),
                                Text('ClaveAcceso: ${value.claveAcceso}'),
                                Text('EsFactura: ${value.esFactura}'),
                                Text('Autorizacion: ${value.autorizacion}'),
                                Text('SubtotalPrevio: ${value.subtotalPrevio}'),
                                Text('Subtotal0: ${value.subtotal0}'),
                                Text('Descuento: ${value.descuento}'),
                                Text('Subtotal: ${value.subtotal}'),
                                Text('Iva: ${value.iva}'),
                                Text('Total: ${value.total}'),
                                Text('PagoEfectivo: ${value.pagoEfectivo}'),
                                Text('PagoTarjetaDebCred: ${value.pagoTarjetaDebCred}'),
                                Text('PagoOtraForma: ${value.pagoOtraForma}'),
                                Text('PagoOtraFormaDetalle: ${value.pagoOtraFormaDetalle}'),
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
                          title: Text('Editar FacturaNotaCredito'),
                          content: CreateEditFacturaNotaCreditoWidget(
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