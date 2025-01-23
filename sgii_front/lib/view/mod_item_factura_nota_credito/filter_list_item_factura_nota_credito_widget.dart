import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_item_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_item_factura_nota_credito.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/agregar_item_factura.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/create_edit_item_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_item_factura_nota_credito/item_item_factura_nota_credito_widget.dart';

class FilterListItemFacturaNotaCreditoWidget extends StatefulWidget {
  final Future<void> Function(BuildContext filterListCargoWidgetContext, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  FilterListItemFacturaNotaCreditoWidget({
    super.key,
    required this.selectedItem,
  });

  @override
  FilterListItemFacturaNotaCreditoWidgetState createState() => FilterListItemFacturaNotaCreditoWidgetState();
}

class FilterListItemFacturaNotaCreditoWidgetState extends State<FilterListItemFacturaNotaCreditoWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>> _searchListWidgetKey = GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>>();
  ItemFacturaNotaCreditoService serv = ItemFacturaNotaCreditoService();


  void reset(){

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(covariant FilterListItemFacturaNotaCreditoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return SearchListWidget<ItemFacturaNotaCredito>(
      key: _searchListWidgetKey,
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        return mostrarDatos(item_);
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<ItemFacturaNotaCredito>> result = await serv.fetchDataFind(
            offset,
            take,
            _nombreController.text.isEmpty ? null : _nombreController.text);
        return result;
      },
      finds: (BuildContext context) {
        return <Widget>[
          Container(
            width: 300,
            height: 60,
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
          )
        ];
      },
      create: (BuildContext context) async {
        Result? res;
        await showDialog(
          context: context,
          builder: (BuildContext alertDialogContext){
            return AlertDialog(
              title: Text('Agregar ItemFacturaNotaCredito'),
              content: CreateEditItemFacturaNotaCreditoWidget(
                  mostrarCancelar: true,
                  item:null,
                  result: (Result r){
                    res = r;
                    if (r.success){
                      //Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                      Nav.navPop(context: alertDialogContext);
                    }
                    //Navigator.of(context).pop();
                    //Navigator.pop(alertDialogContext);
                  }
              ),
            );
          },
        );
        if (res == null){
          return Result(success: false,);
        }
        return res!;
      },

    );
  }

  Widget mostrarDatos(ItemList<DbObj> item){
    return ItemItemFacturaNotaCreditoWidget(
      item: item,
      listWidgetKey: null,
      searchListWidgetKey: _searchListWidgetKey,
      selectedItem: widget.selectedItem,
    );
  }
}


class FilterList01ItemFacturaNotaCreditoWidget extends StatefulWidget {
  final Future<void> Function(BuildContext filterListCargoWidgetContext, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  FilterList01ItemFacturaNotaCreditoWidget({
    super.key,
    required this.selectedItem,
  });

  @override
  FilterList01ItemFacturaNotaCreditoWidgetState createState() => FilterList01ItemFacturaNotaCreditoWidgetState();
}

class FilterList01ItemFacturaNotaCreditoWidgetState extends State<FilterList01ItemFacturaNotaCreditoWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>> _searchListWidgetKey = GlobalKey<SearchListWidgetState<ItemFacturaNotaCredito>>();
  ItemFacturaNotaCreditoService serv = ItemFacturaNotaCreditoService();


  void reset(){

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(covariant FilterList01ItemFacturaNotaCreditoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return SearchListWidget<ItemFacturaNotaCredito>(
      key: _searchListWidgetKey,
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        return mostrarDatos(item_);
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<ItemFacturaNotaCredito>> result = await serv.fetchDataFind(
            offset,
            take,
            _nombreController.text.isEmpty ? null : _nombreController.text);
        return result;
      },
      finds: (BuildContext context) {
        return <Widget>[
          Container(
            width: 300,
            height: 60,
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
          )
        ];
      },
      create: (BuildContext context) async {
        Result? res;
        await showDialog(
          context: context,
          builder: (BuildContext alertDialogContext){
            return Container(
              width: 500,
              child: SingleChildScrollView(
                child: AgregarItemFacturaWidget(
                    item: null,
                    result: (Result r){
                      res = r;
                      if (r.success){
                        //Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                        Nav.navPop(context: alertDialogContext);
                      }
                      //Navigator.of(context).pop();
                      //Navigator.pop(alertDialogContext);
                    },
                    mostrarCancelar: true)
              ),
            );


              /*Container(
                width: 550,
                child: /*CreateEditItemFacturaNotaCreditoWidget(
                  mostrarCancelar: true,
                  item:null,
                  result: (Result r){
                    res = r;
                    if (r.success){
                      //Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                      Nav.navPop(context: alertDialogContext);
                    }
                    //Navigator.of(context).pop();
                    //Navigator.pop(alertDialogContext);
                  }
              ),*/
            );*/
          },
        );
        if (res == null){
          return Result(success: false,);
        }
        return res!;
      },

    );
  }

  Widget mostrarDatos(ItemList<DbObj> item){
    return ItemItemFacturaNotaCreditoWidget(
      item: item,
      listWidgetKey: null,
      searchListWidgetKey: _searchListWidgetKey,
      selectedItem: widget.selectedItem,
    );
  }
}