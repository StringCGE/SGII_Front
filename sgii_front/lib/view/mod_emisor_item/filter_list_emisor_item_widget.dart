import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor_item.dart';
import 'package:sgii_front/service/serv_emisor_item.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_emisor_item/create_edit_emisor_item_widget.dart';
import 'package:sgii_front/view/mod_emisor_item/item_emisor_item_widget.dart';

class FilterListEmisorItemWidget extends StatefulWidget {
  final Future<void> Function(BuildContext filterListCargoWidgetContext, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  FilterListEmisorItemWidget({
    super.key,
    required this.selectedItem,
  });

  @override
  FilterListEmisorItemWidgetState createState() => FilterListEmisorItemWidgetState();
}

class FilterListEmisorItemWidgetState extends State<FilterListEmisorItemWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final GlobalKey<SearchListWidgetState<EmisorItem>> _searchListWidgetKey = GlobalKey<SearchListWidgetState<EmisorItem>>();
  EmisorItemService serv = EmisorItemService();


  void reset(){

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(covariant FilterListEmisorItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return SearchListWidget<EmisorItem>(
      key: _searchListWidgetKey,
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        return mostrarDatos(item_);
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<EmisorItem>> result = await serv.fetchDataFind(
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
              title: Text('Agregar EmisorItem'),
              content: CreateEditEmisorItemWidget(
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
    return ItemEmisorItemWidget(
      item: item,
      listWidgetKey: null,
      searchListWidgetKey: _searchListWidgetKey,
      selectedItem: widget.selectedItem,
    );
  }
}