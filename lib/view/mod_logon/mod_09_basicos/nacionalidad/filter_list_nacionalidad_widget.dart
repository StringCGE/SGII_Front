import 'package:flutter/material.dart';
import 'package:sgii_front/model/basicos/cls_nacionalidad.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/service/serv_nacionalidad.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/nacionalidad/create_edit_nacionalidad_widget.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/nacionalidad/item_nacionalidad_widget.dart';

class FilterListNacionalidadWidget extends StatefulWidget {
  final Future<void> Function(BuildContext filterListCargoWidgetContext, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  FilterListNacionalidadWidget({
    super.key,
    required this.selectedItem,
  });

  @override
  FilterListNacionalidadWidgetState createState() => FilterListNacionalidadWidgetState();
}

class FilterListNacionalidadWidgetState extends State<FilterListNacionalidadWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final GlobalKey<SearchListWidgetState<Nacionalidad>> _searchListWidgetKey = GlobalKey<SearchListWidgetState<Nacionalidad>>();
  NacionalidadService serv = NacionalidadService();


  void reset(){

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(covariant FilterListNacionalidadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return SearchListWidget<Nacionalidad>(
      key: _searchListWidgetKey,
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        return mostrarDatos(item_);
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<Nacionalidad>> result = await serv.fetchDataFind(
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
              title: Text('Agregar Nacionalidad'),
              content: CreateEditNacionalidadWidget(
                  mostrarCancelar: true,
                  item:null,
                  result: (Result r){
                    res = r;
                    if (r.success){
                      Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
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
    return ItemNacionalidadWidget(
      item: item,
      listWidgetKey: null,
      searchListWidgetKey: _searchListWidgetKey,
      selectedItem: widget.selectedItem,
    );
  }
}



